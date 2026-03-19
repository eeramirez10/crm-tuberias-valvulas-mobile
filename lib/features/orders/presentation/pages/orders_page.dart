import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../domain/entities/order.dart';
import '../providers/orders_providers.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  OrderStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordersControllerProvider);

    return CrmPageShell(
      title: 'Pedidos',
      subtitle: 'Ejecucion e inventario',
      actions: <Widget>[
        ActionSquare(
          icon: Icons.refresh_rounded,
          onTap: () async {
            try {
              await ref.read(ordersControllerProvider.notifier).refresh();
              ref.invalidate(dashboardSummaryProvider);
              if (context.mounted) {
                AppToast.info(context, 'Pedidos actualizados.');
              }
            } catch (_) {
              if (context.mounted) {
                AppToast.info(context, 'No se pudieron actualizar pedidos.');
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
              await ref.read(ordersControllerProvider.notifier).refresh();
              ref.invalidate(dashboardSummaryProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const SizedBox(height: 8),
                _OrderStatusFilter(
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
                      child: Text('No hay pedidos para este filtro.'),
                    ),
                  )
                else
                  ...filtered.map(
                    (order) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OrderCard(
                        order: order,
                        processing: viewModel.isProcessing(order.id),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Error cargando pedidos: $error')),
      ),
    );
  }
}

class _OrderStatusFilter extends StatelessWidget {
  const _OrderStatusFilter({required this.selected, required this.onSelected});

  final OrderStatus? selected;
  final ValueChanged<OrderStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        ChoiceChip(
          label: const Text('Todos'),
          selected: selected == null,
          onSelected: (_) => onSelected(null),
        ),
        ...OrderStatus.values.map(
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

class _OrderCard extends ConsumerWidget {
  const _OrderCard({required this.order, required this.processing});

  final Order order;
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
                        order.code,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(order.customerName),
                    ],
                  ),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${currency.format(order.total)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            Text('Promesa entrega: ${order.promisedDate}'),
            Text(
              order.inventoryReserved
                  ? 'Inventario reservado'
                  : 'Inventario pendiente de reservar',
              style: TextStyle(
                color: order.inventoryReserved
                    ? Colors.green.shade900
                    : Colors.orange.shade900,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<OrderStatus>(
              initialValue: order.status,
              decoration: const InputDecoration(labelText: 'Estado logistica'),
              items: OrderStatus.values
                  .map(
                    (status) => DropdownMenuItem<OrderStatus>(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: processing
                  ? null
                  : (selected) async {
                      if (selected == null || selected == order.status) {
                        return;
                      }

                      try {
                        await ref
                            .read(ordersControllerProvider.notifier)
                            .updateStatus(orderId: order.id, status: selected);

                        await ref
                            .read(activitiesTimelineControllerProvider.notifier)
                            .logInteraction(
                              type: 'Pedido',
                              summary:
                                  'Pedido ${order.code} cambiado a ${selected.label}.',
                            );

                        if (selected == OrderStatus.shipped) {
                          final due = DateFormat(
                            'yyyy-MM-dd',
                          ).format(DateTime.now().add(const Duration(days: 2)));
                          await ref
                              .read(tasksControllerProvider.notifier)
                              .createFollowUpTask(
                                title: 'Confirmar entrega ${order.code}',
                                type: 'Entrega',
                                dueDate: due,
                                relatedTo: order.id,
                              );
                        }

                        ref.invalidate(dashboardSummaryProvider);
                        ref.invalidate(productsProvider());
                        if (context.mounted) {
                          AppToast.success(context, 'Pedido actualizado.');
                        }
                      } catch (error) {
                        if (context.mounted) {
                          AppToast.info(
                            context,
                            'No se pudo actualizar: $error',
                          );
                        }
                      }
                    },
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                context.push('/orders/${order.id}');
              },
              icon: const Icon(Icons.visibility_rounded, size: 18),
              label: const Text('Ver detalle'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (status) {
      OrderStatus.newOrder => (AppColors.yellowSoft, AppColors.black),
      OrderStatus.picking => (Colors.orange.shade100, Colors.orange.shade900),
      OrderStatus.shipped => (Colors.lightBlue.shade100, Colors.blue.shade900),
      OrderStatus.delivered => (Colors.green.shade100, Colors.green.shade900),
      OrderStatus.cancelled => (Colors.red.shade100, Colors.red.shade900),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}
