import 'package:crm_tuberias_valvulas_mobile/core/design_system/card_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../ai_assistant/presentation/providers/ai_assistant_providers.dart';
import '../../../customers/presentation/providers/customers_providers.dart';
import '../../../leads/presentation/providers/leads_providers.dart';
import '../../../tasks/domain/entities/task_item.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../providers/dashboard_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryState = ref.watch(dashboardSummaryProvider);
    final customersState = ref.watch(customersProvider());
    final leadsState = ref.watch(leadsProvider());
    final tasksState = ref.watch(tasksControllerProvider);
    final activitiesState = ref.watch(activitiesTimelineControllerProvider);
    final riskSummaryState = ref.watch(aiRiskSummaryProvider);

    return CrmPageShell(
      title: 'Dashboard',
      subtitle: 'Bienvenido de vuelta',
      actions: <Widget>[
        ActionSquare(
          icon: Icons.notifications_none_rounded,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No hay alertas nuevas.')),
            );
          },
        ),
        const SizedBox(width: 8),
        ActionSquare(
          icon: Icons.refresh_rounded,
          onTap: () {
            ref.invalidate(dashboardSummaryProvider);
            ref.invalidate(customersProvider());
            ref.invalidate(leadsProvider());
            ref.invalidate(tasksControllerProvider);
            ref.invalidate(activitiesTimelineControllerProvider);
            ref.invalidate(aiRiskSummaryProvider);
          },
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(customersProvider());
          ref.invalidate(leadsProvider());
          ref.invalidate(tasksControllerProvider);
          ref.invalidate(activitiesTimelineControllerProvider);
          ref.invalidate(aiRiskSummaryProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 90,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.blackSoft,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Actualizado hace 1h',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 14),
            summaryState.when(
              data: (summary) => _SummaryGrid(summary: summary),
              loading: () => const _LoadingCard(height: 220),
              error: (_, _) =>
                  const _ErrorCard(message: 'No se pudo cargar resumen.'),
            ),
            const SizedBox(height: 12),
            summaryState.when(
              data: (summary) => CardApp(
                child: _SectionCard(
                  title: 'Cotizaciones del mes',
                  child: _QuotesKpiRow(summary: summary),
                ),
              ),
              loading: () => const _LoadingCard(height: 100),
              error: (_, _) =>
                  const _ErrorCard(message: 'No se pudo cargar cotizaciones.'),
            ),
            const SizedBox(height: 12),
            summaryState.when(
              data: (summary) => CardApp(
                child: _SectionCard(
                  title: 'Pedidos del mes',
                  child: _OrdersKpiRow(summary: summary),
                ),
              ),
              loading: () => const _LoadingCard(height: 90),
              error: (_, _) =>
                  const _ErrorCard(message: 'No se pudo cargar pedidos.'),
            ),
            const SizedBox(height: 12),
            summaryState.when(
              data: (summary) => CardApp(
                child: _SectionCard(
                  title: 'Top productos cotizados',
                  child: _TopProductsList(items: summary.topQuotedProducts),
                ),
              ),
              loading: () => const _LoadingCard(height: 90),
              error: (_, _) =>
                  const _ErrorCard(message: 'No se pudo cargar productos top.'),
            ),
            const SizedBox(height: 12),
            CardApp(
              child: _SectionCard(
                title: 'Panel de riesgo IA',
                child: riskSummaryState.when(
                  data: (risk) => _RiskSummaryRow(
                    high: risk.high,
                    medium: risk.medium,
                    low: risk.low,
                  ),
                  loading: () => const _LoadingCard(height: 108),
                  error: (_, _) =>
                      const Text('No se pudo cargar panel de riesgo.'),
                ),
              ),
            ),
            const SizedBox(height: 14),
            CardApp(
              child: _SectionCard(
                title: 'Leads activos',
                child: leadsState.when(
                  data: (items) => Column(
                    children: items
                        .take(2)
                        .map(
                          (lead) => _DataLine(
                            title: lead.companyName,
                            subtitle: '${lead.status} • ${lead.nextActionDate}',
                            trailing: _currency(lead.estimatedAmount),
                          ),
                        )
                        .toList(growable: false),
                  ),
                  loading: () => const _LoadingCard(height: 112),
                  error: (_, _) => const Text('No se pudo cargar leads.'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CardApp(
              child: _SectionCard(
                title: 'Clientes recientes',
                child: customersState.when(
                  data: (items) => Column(
                    children: items
                        .take(2)
                        .map(
                          (customer) => _DataLine(
                            title: customer.name,
                            subtitle:
                                '${customer.city} • ${customer.contactName}',
                            trailing: customer.creditStatus,
                          ),
                        )
                        .toList(growable: false),
                  ),
                  loading: () => const _LoadingCard(height: 112),
                  error: (_, _) => const Text('No se pudo cargar clientes.'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CardApp(
              child: _SectionCard(
                title: 'Tareas abiertas',
                child: tasksState.when(
                  data: (items) => _TasksList(items: items),
                  loading: () => const _LoadingCard(height: 120),
                  error: (_, _) => const Text('No se pudo cargar tareas.'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CardApp(
              child: _SectionCard(
                title: 'Actividad reciente',
                child: activitiesState.when(
                  data: (items) => Column(
                    children: items
                        .take(2)
                        .map(
                          (activity) => _DataLine(
                            title: activity.summary,
                            subtitle: '${activity.type} • ${activity.owner}',
                            trailing: DateFormat.Hm().format(activity.createdAt),
                          ),
                        )
                        .toList(growable: false),
                  ),
                  loading: () => const _LoadingCard(height: 112),
                  error: (_, _) => const Text('No se pudo cargar actividades.'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TopProductsList extends StatelessWidget {
  const _TopProductsList({required this.items});

  final List<DashboardTopQuotedProduct> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('Aun no hay cotizaciones este mes.');
    }

    return Column(
      children: items
          .map(
            (item) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: AppColors.yellow,
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.black,
                  size: 18,
                ),
              ),
              title: Text(item.productName),
              trailing: Text(
                '${item.quantity} u',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _OrdersKpiRow extends StatelessWidget {
  const _OrdersKpiRow({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _RiskPill(
            label: 'Pedidos',
            value: summary.ordersThisMonth,
            background: Colors.lightBlue.shade100,
            foreground: Colors.blue.shade900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiAmountPill(
            label: 'Entrega a tiempo',
            value: '${(summary.ordersOnTimeRate * 100).toStringAsFixed(0)}%',
            background: Colors.green.shade100,
            foreground: Colors.green.shade900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RiskPill(
            label: 'Backlog',
            value: summary.ordersBacklog,
            background: Colors.orange.shade100,
            foreground: Colors.orange.shade900,
          ),
        ),
      ],
    );
  }
}

class _QuotesKpiRow extends StatelessWidget {
  const _QuotesKpiRow({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _RiskPill(
            label: 'Emitidas',
            value: summary.quotesThisMonth,
            background: AppColors.yellowSoft,
            foreground: AppColors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiAmountPill(
            label: 'Aprobacion',
            value: '${(summary.quotesApprovalRate * 100).toStringAsFixed(0)}%',
            background: Colors.green.shade100,
            foreground: Colors.green.shade900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiAmountPill(
            label: 'Monto aprobado',
            value: _currency(summary.quotesApprovedAmount),
            background: Colors.lightBlue.shade100,
            foreground: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}

class _RiskSummaryRow extends StatelessWidget {
  const _RiskSummaryRow({
    required this.high,
    required this.medium,
    required this.low,
  });

  final int high;
  final int medium;
  final int low;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _RiskPill(
            label: 'Alto',
            value: high,
            background: Colors.red.shade100,
            foreground: Colors.red.shade900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RiskPill(
            label: 'Medio',
            value: medium,
            background: AppColors.yellowSoft,
            foreground: AppColors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RiskPill(
            label: 'Bajo',
            value: low,
            background: Colors.green.shade100,
            foreground: Colors.green.shade900,
          ),
        ),
      ],
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({
    required this.label,
    required this.value,
    required this.background,
    required this.foreground,
  });

  final String label;
  final int value;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$value',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

class _KpiAmountPill extends StatelessWidget {
  const _KpiAmountPill({
    required this.label,
    required this.value,
    required this.background,
    required this.foreground,
  });

  final String label;
  final String value;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final metrics = <({String title, String value, IconData icon})>[
      (
        title: 'Solicitudes',
        value: '${summary.activeLeads}',
        icon: Icons.request_page,
      ),
      (
        title: 'Tickets',
        value: '${summary.openTasks}',
        icon: Icons.support_agent,
      ),
      (
        title: 'Pipeline',
        value: '362k',
        // _currency(summary.pipelineValue),
        icon: Icons.account_tree_rounded,
      ),
      (
        title: 'Conversion',
        value: '${(summary.conversionRate * 100).toStringAsFixed(0)}%',
        icon: Icons.trending_up,
      ),
    ];

    return GridView.builder(
      itemCount: metrics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.04,
      ),
      itemBuilder: (context, index) {
        final item = metrics[index];
        return CardApp(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: AppColors.black),
                  ),
                  const Spacer(),
                  Text(
                    item.value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
          
              Spacer(),
          
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.black87),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TasksList extends ConsumerWidget {
  const _TasksList({required this.items});

  final List<TaskItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Text('No hay tareas pendientes.');
    }

    return Column(
      children: items
          .take(3)
          .map(
            (task) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(task.title),
              subtitle: Text('${task.type} • ${task.dueDate}'),
              trailing: FilledButton.tonalIcon(
                onPressed: () async {
                  await ref
                      .read(tasksControllerProvider.notifier)
                      .complete(task.id);
                },
                icon: const Icon(Icons.check),
                label: const Text('Hecha'),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _DataLine extends StatelessWidget {
  const _DataLine({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        trailing,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: AppColors.black),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Card(child: Center(child: CircularProgressIndicator())),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(message)),
    );
  }
}

String _currency(double value) {
  return NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(value);
}
