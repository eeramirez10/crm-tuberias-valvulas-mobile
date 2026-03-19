import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../domain/entities/create_quote_input.dart';
import '../../domain/entities/quote.dart';
import '../providers/quotes_providers.dart';

class QuotesPage extends ConsumerStatefulWidget {
  const QuotesPage({super.key});

  @override
  ConsumerState<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends ConsumerState<QuotesPage> {
  QuoteStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quotesControllerProvider);

    return CrmPageShell(
      title: 'Cotizaciones',
      subtitle: 'Borrador, enviadas y conversion a pedido',
      actions: <Widget>[
        ActionSquare(
          icon: Icons.add,
          onTap: () async {
            await _openCreateDialog(context);
          },
        ),
        const SizedBox(width: 8),
        ActionSquare(
          icon: Icons.refresh_rounded,
          onTap: () async {
            try {
              await ref.read(quotesControllerProvider.notifier).refresh();
              ref.invalidate(dashboardSummaryProvider);
              if (context.mounted) {
                AppToast.info(context, 'Cotizaciones actualizadas.');
              }
            } catch (_) {
              if (context.mounted) {
                AppToast.info(
                  context,
                  'No se pudieron actualizar cotizaciones.',
                );
              }
            }
          },
        ),
      ],
      child: state.when(
        data: (viewModel) {
          final filtered = _filter == null
              ? viewModel.items
              : viewModel.items
                    .where((item) => item.status == _filter)
                    .toList(growable: false);

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(quotesControllerProvider.notifier).refresh();
              ref.invalidate(dashboardSummaryProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const SizedBox(height: 8),
                _StatusFilter(
                  selected: _filter,
                  onSelected: (value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                if (filtered.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No hay cotizaciones para este filtro.'),
                    ),
                  )
                else
                  ...filtered.map(
                    (quote) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _QuoteCard(
                        quote: quote,
                        processing: viewModel.isProcessing(quote.id),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Error cargando cotizaciones: $error')),
      ),
    );
  }

  Future<void> _openCreateDialog(BuildContext context) async {
    final customerController = TextEditingController();
    final relatedIdController = TextEditingController(text: 'lead-001');
    final itemsController = TextEditingController(text: '4');
    final subtotalController = TextEditingController(text: '120000');
    final discountController = TextEditingController(text: '5000');
    final taxController = TextEditingController(text: '18400');
    final validUntilController = TextEditingController(text: '2026-03-30');
    String relatedType = 'lead';

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nueva cotizacion'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: customerController,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: relatedType,
                  decoration: const InputDecoration(labelText: 'Relacionado a'),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: 'lead', child: Text('Lead')),
                    DropdownMenuItem(
                      value: 'opportunity',
                      child: Text('Oportunidad'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      relatedType = value;
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: relatedIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID relacionado',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: itemsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Numero de items',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: subtotalController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Subtotal'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: discountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Descuento'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: taxController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Impuestos'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: validUntilController,
                  decoration: const InputDecoration(
                    labelText: 'Vigencia (YYYY-MM-DD)',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final customerName = customerController.text.trim();
                final relatedId = relatedIdController.text.trim();

                if (customerName.isEmpty || relatedId.isEmpty) {
                  AppToast.info(
                    dialogContext,
                    'Cliente e ID son obligatorios.',
                  );
                  return;
                }

                try {
                  final createdQuote = await ref
                      .read(quotesControllerProvider.notifier)
                      .createQuote(
                        CreateQuoteInput(
                          customerName: customerName,
                          relatedType: relatedType,
                          relatedId: relatedId,
                          itemsCount: int.tryParse(itemsController.text) ?? 1,
                          subtotal:
                              double.tryParse(subtotalController.text) ?? 0,
                          discount:
                              double.tryParse(discountController.text) ?? 0,
                          tax: double.tryParse(taxController.text) ?? 0,
                          validUntil: validUntilController.text.trim().isEmpty
                              ? '2026-03-30'
                              : validUntilController.text.trim(),
                        ),
                      );

                  await ref
                      .read(activitiesTimelineControllerProvider.notifier)
                      .logInteraction(
                        type: 'Cotizacion',
                        summary:
                            'Cotizacion ${createdQuote.code} creada para ${createdQuote.customerName}.',
                      );
                  await ref
                      .read(tasksControllerProvider.notifier)
                      .createFollowUpTask(
                        title: 'Enviar cotizacion ${createdQuote.code}',
                        type: 'Cotizacion',
                        dueDate: createdQuote.validUntil,
                        relatedTo: createdQuote.relatedId,
                      );
                  ref.invalidate(dashboardSummaryProvider);

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(true);
                  }
                } catch (_) {
                  if (dialogContext.mounted) {
                    AppToast.info(
                      dialogContext,
                      'No se pudo crear la cotizacion.',
                    );
                  }
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );

    customerController.dispose();
    relatedIdController.dispose();
    itemsController.dispose();
    subtotalController.dispose();
    discountController.dispose();
    taxController.dispose();
    validUntilController.dispose();

    if (created == true && context.mounted) {
      AppToast.success(context, 'Cotizacion creada con tarea y actividad.');
    }
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.selected, required this.onSelected});

  final QuoteStatus? selected;
  final ValueChanged<QuoteStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        ChoiceChip(
          label: const Text('Todas'),
          selected: selected == null,
          onSelected: (_) => onSelected(null),
        ),
        ...QuoteStatus.values
            .where((status) => status != QuoteStatus.converted)
            .map(
              (status) => ChoiceChip(
                label: Text(status.label),
                selected: selected == status,
                onSelected: (_) => onSelected(status),
              ),
            ),
      ],
    );
  }
}

class _QuoteCard extends ConsumerWidget {
  const _QuoteCard({required this.quote, required this.processing});

  final Quote quote;
  final bool processing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        quote.code,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        quote.customerName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: quote.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${currency.format(quote.total)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text('Vigente hasta: ${quote.validUntil}'),
            Text('Creada: ${quote.createdAt}'),
            const SizedBox(height: 10),
            DropdownButtonFormField<QuoteStatus>(
              initialValue: quote.status,
              decoration: const InputDecoration(labelText: 'Estado comercial'),
              items: QuoteStatus.values
                  .where((status) => status != QuoteStatus.converted)
                  .map(
                    (status) => DropdownMenuItem<QuoteStatus>(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: processing
                  ? null
                  : (selected) async {
                      if (selected == null || selected == quote.status) {
                        return;
                      }

                      try {
                        await ref
                            .read(quotesControllerProvider.notifier)
                            .updateStatus(quoteId: quote.id, status: selected);
                        await ref
                            .read(activitiesTimelineControllerProvider.notifier)
                            .logInteraction(
                              type: 'Cotizacion',
                              summary:
                                  'Cotizacion ${quote.code} actualizada a ${selected.label}.',
                            );
                        ref.invalidate(dashboardSummaryProvider);
                        if (context.mounted) {
                          AppToast.success(
                            context,
                            'Estado de cotizacion actualizado.',
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          AppToast.info(
                            context,
                            'No se pudo actualizar el estado.',
                          );
                        }
                      }
                    },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.black),
                    foregroundColor: AppColors.black,
                  ),
                  onPressed: () {
                    context.push('/quotes/${quote.id}');
                  },
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: const Text('Ver detalle'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.black),
                    foregroundColor: AppColors.black,
                  ),
                  onPressed:
                      processing ||
                          quote.status == QuoteStatus.converted ||
                          quote.status == QuoteStatus.rejected
                      ? null
                      : () async {
                          try {
                            final result = await ref
                                .read(quotesControllerProvider.notifier)
                                .convertToOrder(quote.id);
                            final dueDate = DateFormat('yyyy-MM-dd').format(
                              DateTime.now().add(const Duration(days: 1)),
                            );

                            await ref
                                .read(tasksControllerProvider.notifier)
                                .createFollowUpTask(
                                  title: 'Coordinar pedido ${result.orderId}',
                                  type: 'Pedido',
                                  dueDate: dueDate,
                                  relatedTo: quote.id,
                                );
                            await ref
                                .read(
                                  activitiesTimelineControllerProvider.notifier,
                                )
                                .logInteraction(
                                  type: 'Pedido',
                                  summary:
                                      'Cotizacion ${quote.code} convertida a pedido ${result.orderId}.',
                                );
                            ref.invalidate(dashboardSummaryProvider);

                            if (context.mounted) {
                              AppToast.success(
                                context,
                                'Pedido ${result.orderId} creado y seguimiento generado.',
                              );
                            }
                          } catch (_) {
                            if (context.mounted) {
                              AppToast.info(
                                context,
                                'No se pudo convertir a pedido.',
                              );
                            }
                          }
                        },
                  icon: processing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.shopping_cart_checkout_rounded,
                          size: 18,
                        ),
                  label: Text(
                    processing ? 'Procesando...' : 'Convertir a pedido',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final QuoteStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (status) {
      QuoteStatus.draft => (AppColors.yellowSoft, AppColors.black),
      QuoteStatus.sent => (Colors.lightBlue.shade100, Colors.blue.shade900),
      QuoteStatus.approved => (Colors.green.shade100, Colors.green.shade900),
      QuoteStatus.rejected => (Colors.red.shade100, Colors.red.shade900),
      QuoteStatus.converted => (Colors.purple.shade100, Colors.purple.shade900),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }
}
