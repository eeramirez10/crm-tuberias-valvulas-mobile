import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../domain/entities/create_quote_input.dart';
import '../../domain/entities/create_quote_line_input.dart';
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
      subtitle: 'Lineas de producto y conversion a pedido',
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
    late List<Product> products;
    try {
      products = await ref.read(productsProvider().future);
    } catch (_) {
      if (context.mounted) {
        AppToast.info(context, 'No se pudo cargar el catalogo de productos.');
      }
      return;
    }

    if (products.isEmpty) {
      if (context.mounted) {
        AppToast.info(context, 'No hay productos disponibles en el catalogo.');
      }
      return;
    }
    if (!context.mounted) {
      return;
    }

    final customerController = TextEditingController();
    final relatedIdController = TextEditingController(text: 'lead-001');
    final validUntilController = TextEditingController(text: '2026-03-30');
    final qtyController = TextEditingController(text: '1');
    final unitPriceController = TextEditingController(
      text: products.first.listPrice.toStringAsFixed(2),
    );
    final discountController = TextEditingController(text: '0');
    var relatedType = 'lead';
    var selectedProductId = products.first.id;
    final lines = <_DraftQuoteLine>[];

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final selectedProduct = products.firstWhere(
              (item) => item.id == selectedProductId,
            );
            final metrics = _QuoteDraftMetrics.fromLines(lines, taxRate: 0.16);

            return AlertDialog(
              title: const Text('Nueva cotizacion por lineas'),
              content: SizedBox(
                width: 560,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        controller: customerController,
                        decoration: const InputDecoration(labelText: 'Cliente'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: relatedType,
                        decoration: const InputDecoration(
                          labelText: 'Relacionado a',
                        ),
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
                        controller: validUntilController,
                        decoration: const InputDecoration(
                          labelText: 'Vigencia (YYYY-MM-DD)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Agregar linea de producto',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedProductId,
                        decoration: const InputDecoration(
                          labelText: 'Producto',
                        ),
                        items: products
                            .map(
                              (product) => DropdownMenuItem<String>(
                                value: product.id,
                                child: Text('${product.sku} • ${product.name}'),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          selectedProductId = value;
                          final selected = products.firstWhere(
                            (item) => item.id == selectedProductId,
                          );
                          unitPriceController.text = selected.listPrice
                              .toStringAsFixed(2);
                          setDialogState(() {});
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Cantidad',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: unitPriceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Precio unitario',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: discountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Desc. %',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          _InfoPill(
                            label: 'Stock ${selectedProduct.stock}',
                            color: selectedProduct.stock <= 30
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                          ),
                          _InfoPill(
                            label: 'Min ${_money(selectedProduct.minPrice)}',
                            color: Colors.orange.shade100,
                          ),
                          _InfoPill(
                            label: 'Lista ${_money(selectedProduct.listPrice)}',
                            color: AppColors.yellowSoft,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final quantity =
                                int.tryParse(qtyController.text) ?? 0;
                            final unitPrice =
                                double.tryParse(unitPriceController.text) ?? 0;
                            final discountPercent =
                                double.tryParse(discountController.text) ?? 0;
                            final discountRate = (discountPercent / 100).clamp(
                              0.0,
                              0.8,
                            );

                            if (quantity <= 0) {
                              AppToast.info(context, 'Cantidad invalida.');
                              return;
                            }
                            if (quantity > selectedProduct.stock) {
                              AppToast.info(
                                context,
                                'Stock insuficiente para ${selectedProduct.name}.',
                              );
                              return;
                            }
                            if (unitPrice < selectedProduct.minPrice) {
                              AppToast.info(
                                context,
                                'Precio por debajo del minimo permitido.',
                              );
                              return;
                            }

                            lines.add(
                              _DraftQuoteLine(
                                product: selectedProduct,
                                quantity: quantity,
                                unitPrice: unitPrice,
                                discountRate: discountRate,
                              ),
                            );

                            qtyController.text = '1';
                            discountController.text = '0';
                            setDialogState(() {});
                          },
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: const Text('Agregar linea'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Lineas (${lines.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      if (lines.isEmpty)
                        const Text('Aun no agregas lineas de producto.')
                      else
                        ...lines.asMap().entries.map((entry) {
                          final index = entry.key;
                          final line = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.panelBorder),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${line.product.sku} • ${line.product.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      Text(
                                        '${line.quantity} x ${_money(line.unitPrice)}  desc ${(line.discountRate * 100).toStringAsFixed(1)}%',
                                      ),
                                      Text(
                                        'Total linea: ${_money(line.lineTotal)} • Margen ${(line.marginRate * 100).toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: line.marginRate < 0.15
                                              ? Colors.orange.shade900
                                              : Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    lines.removeAt(index);
                                    setDialogState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.panelCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.panelBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _SummaryLine(
                              label: 'Subtotal',
                              value: _money(metrics.subtotal),
                            ),
                            _SummaryLine(
                              label: 'Descuento',
                              value: _money(metrics.discount),
                            ),
                            _SummaryLine(
                              label: 'IVA (16%)',
                              value: _money(metrics.tax),
                            ),
                            const Divider(height: 14),
                            _SummaryLine(
                              label: 'Total',
                              value: _money(metrics.total),
                              strong: true,
                            ),
                            _SummaryLine(
                              label: 'Margen estimado',
                              value:
                                  '${(metrics.marginRate * 100).toStringAsFixed(1)}%',
                              strong: true,
                            ),
                            if (metrics.hasLowMargin)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Advertencia: hay lineas con margen bajo (<15%).',
                                  style: TextStyle(
                                    color: Colors.orange.shade900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                      AppToast.info(context, 'Cliente e ID son obligatorios.');
                      return;
                    }

                    if (lines.isEmpty) {
                      AppToast.info(context, 'Agrega al menos una linea.');
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
                              validUntil:
                                  validUntilController.text.trim().isEmpty
                                  ? '2026-03-30'
                                  : validUntilController.text.trim(),
                              taxRate: 0.16,
                              lines: lines
                                  .map(
                                    (line) => CreateQuoteLineInput(
                                      productId: line.product.id,
                                      quantity: line.quantity,
                                      unitPrice: line.unitPrice,
                                      discountRate: line.discountRate,
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                          );

                      await ref
                          .read(activitiesTimelineControllerProvider.notifier)
                          .logInteraction(
                            type: 'Cotizacion',
                            summary:
                                'Cotizacion ${createdQuote.code} creada para ${createdQuote.customerName} con ${createdQuote.itemsCount} linea(s).',
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
                    } catch (error) {
                      if (dialogContext.mounted) {
                        AppToast.info(
                          context,
                          'No se pudo crear la cotizacion: $error',
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
      },
    );

    customerController.dispose();
    relatedIdController.dispose();
    validUntilController.dispose();
    qtyController.dispose();
    unitPriceController.dispose();
    discountController.dispose();

    if (created == true && context.mounted) {
      AppToast.success(context, 'Cotizacion creada con tarea y actividad.');
    }
  }

  String _money(double value) {
    return NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(value);
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
            Text(
              'Lineas: ${quote.itemsCount} • Margen ${(quote.marginRate * 100).toStringAsFixed(1)}%',
            ),
            Text('Vigente hasta: ${quote.validUntil}'),
            Text('Creada: ${quote.createdAt}'),
            const SizedBox(height: 10),
            DropdownButtonFormField<QuoteStatus>(
              initialValue: quote.status,
              decoration: const InputDecoration(labelText: 'Estado comercial'),
              items: QuoteStatus.values
                  .map(
                    (status) => DropdownMenuItem<QuoteStatus>(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: processing || quote.status == QuoteStatus.converted
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.black,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DraftQuoteLine {
  const _DraftQuoteLine({
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.discountRate,
  });

  final Product product;
  final int quantity;
  final double unitPrice;
  final double discountRate;

  double get lineSubtotal => quantity * unitPrice;
  double get lineDiscount => lineSubtotal * discountRate;
  double get lineTotal => lineSubtotal - lineDiscount;
  double get lineCost => quantity * product.unitCost;
  double get marginRate =>
      lineTotal <= 0 ? 0 : (lineTotal - lineCost) / lineTotal;
}

class _QuoteDraftMetrics {
  const _QuoteDraftMetrics({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.marginRate,
    required this.hasLowMargin,
  });

  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double marginRate;
  final bool hasLowMargin;

  factory _QuoteDraftMetrics.fromLines(
    List<_DraftQuoteLine> lines, {
    required double taxRate,
  }) {
    var subtotal = 0.0;
    var discount = 0.0;
    var revenue = 0.0;
    var cost = 0.0;
    var hasLowMargin = false;

    for (final line in lines) {
      subtotal += line.lineSubtotal;
      discount += line.lineDiscount;
      revenue += line.lineTotal;
      cost += line.lineCost;
      if (line.marginRate < 0.15) {
        hasLowMargin = true;
      }
    }

    final taxable = (subtotal - discount).clamp(0, double.infinity).toDouble();
    final tax = taxable * taxRate;
    final total = taxable + tax;
    final marginRate = revenue <= 0 ? 0.0 : (revenue - cost) / revenue;

    return _QuoteDraftMetrics(
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      marginRate: marginRate,
      hasLowMargin: hasLowMargin,
    );
  }
}
