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
import '../../domain/entities/quote.dart';
import '../providers/quotes_providers.dart';

class QuoteDetailsPage extends ConsumerWidget {
  const QuoteDetailsPage({super.key, required this.quoteId});

  final String quoteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(quoteDetailsProvider(quoteId));
    final viewModelState = ref.watch(quotesControllerProvider);

    final processing =
        viewModelState.valueOrNull?.isProcessing(quoteId) ?? false;

    return CrmPageShell(
      title: 'Detalle de cotizacion',
      subtitle: quoteId,
      actions: <Widget>[
        ActionSquare(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
        const SizedBox(width: 8),
        ActionSquare(
          icon: Icons.refresh_rounded,
          onTap: () {
            ref.invalidate(quoteDetailsProvider(quoteId));
          },
        ),
      ],
      child: detailState.when(
        data: (quote) {
          final currency = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              quote.code,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          _StatusChip(status: quote.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        quote.customerName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Relacionado: ${quote.relatedType} • ${quote.relatedId}',
                      ),
                      Text('Creada: ${quote.createdAt}'),
                      Text('Vigencia: ${quote.validUntil}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Resumen financiero',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _AmountLine(
                        label: 'Subtotal',
                        value: currency.format(quote.subtotal),
                      ),
                      _AmountLine(
                        label: 'Descuento',
                        value: currency.format(quote.discount),
                      ),
                      _AmountLine(
                        label: 'Impuestos',
                        value: currency.format(quote.tax),
                      ),
                      const Divider(height: 20),
                      _AmountLine(
                        label: 'Total',
                        value: currency.format(quote.total),
                        highlighted: true,
                      ),
                      const SizedBox(height: 6),
                      Text('Items: ${quote.itemsCount}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Acciones comerciales',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<QuoteStatus>(
                        initialValue: quote.status,
                        decoration: const InputDecoration(
                          labelText: 'Actualizar estado',
                        ),
                        items: QuoteStatus.values
                            .map(
                              (status) => DropdownMenuItem<QuoteStatus>(
                                value: status,
                                child: Text(status.label),
                              ),
                            )
                            .toList(growable: false),
                        onChanged:
                            processing || quote.status == QuoteStatus.converted
                            ? null
                            : (selected) async {
                                if (selected == null ||
                                    selected == quote.status) {
                                  return;
                                }
                                try {
                                  await ref
                                      .read(quotesControllerProvider.notifier)
                                      .updateStatus(
                                        quoteId: quote.id,
                                        status: selected,
                                      );
                                  await ref
                                      .read(
                                        activitiesTimelineControllerProvider
                                            .notifier,
                                      )
                                      .logInteraction(
                                        type: 'Cotizacion',
                                        summary:
                                            'Cotizacion ${quote.code} actualizada a ${selected.label}.',
                                      );
                                  ref.invalidate(dashboardSummaryProvider);
                                  ref.invalidate(quoteDetailsProvider(quoteId));
                                  if (context.mounted) {
                                    AppToast.success(
                                      context,
                                      'Estado actualizado.',
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
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
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
                                    final dueDate = DateFormat('yyyy-MM-dd')
                                        .format(
                                          DateTime.now().add(
                                            const Duration(days: 1),
                                          ),
                                        );

                                    await ref
                                        .read(tasksControllerProvider.notifier)
                                        .createFollowUpTask(
                                          title:
                                              'Coordinar pedido ${result.orderId}',
                                          type: 'Pedido',
                                          dueDate: dueDate,
                                          relatedTo: quote.id,
                                        );
                                    await ref
                                        .read(
                                          activitiesTimelineControllerProvider
                                              .notifier,
                                        )
                                        .logInteraction(
                                          type: 'Pedido',
                                          summary:
                                              'Cotizacion ${quote.code} convertida a pedido ${result.orderId}.',
                                        );
                                    ref.invalidate(dashboardSummaryProvider);
                                    ref.invalidate(
                                      quoteDetailsProvider(quoteId),
                                    );

                                    if (context.mounted) {
                                      AppToast.success(
                                        context,
                                        'Pedido ${result.orderId} generado.',
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.shopping_cart_checkout_rounded,
                                ),
                          label: Text(
                            processing ? 'Procesando...' : 'Convertir a pedido',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('No se pudo cargar detalle de cotizacion: $error'),
        ),
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  const _AmountLine({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: highlighted ? AppColors.black : Colors.black87,
              fontWeight: highlighted ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
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
