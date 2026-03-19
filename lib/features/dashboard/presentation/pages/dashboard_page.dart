import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../activities/presentation/providers/activities_providers.dart';
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
    final activitiesState = ref.watch(activitiesProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(customersProvider());
          ref.invalidate(leadsProvider());
          ref.invalidate(tasksControllerProvider);
          ref.invalidate(activitiesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(
              'CRM Distribuidora',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Resumen comercial en tiempo real (mock)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            summaryState.when(
              data: (summary) => _SummaryGrid(summary: summary),
              loading: () => const _LoadingCard(height: 160),
              error: (_, _) =>
                  const _ErrorCard(message: 'No se pudo cargar resumen.'),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Clientes recientes',
              child: customersState.when(
                data: (items) => Column(
                  children: items
                      .take(3)
                      .map(
                        (customer) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(customer.name),
                          subtitle: Text(
                            '${customer.city} • ${customer.contactName}',
                          ),
                          trailing: Text(customer.creditStatus),
                        ),
                      )
                      .toList(growable: false),
                ),
                loading: () => const _LoadingCard(height: 120),
                error: (_, _) => const Text('No se pudo cargar clientes.'),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Leads activos',
              child: leadsState.when(
                data: (items) => Column(
                  children: items
                      .take(3)
                      .map(
                        (lead) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(lead.companyName),
                          subtitle: Text(
                            '${lead.status} • ${lead.nextActionDate}',
                          ),
                          trailing: Text(_currency(lead.estimatedAmount)),
                        ),
                      )
                      .toList(growable: false),
                ),
                loading: () => const _LoadingCard(height: 120),
                error: (_, _) => const Text('No se pudo cargar leads.'),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Tareas abiertas',
              child: tasksState.when(
                data: (items) => _TasksList(items: items),
                loading: () => const _LoadingCard(height: 120),
                error: (_, _) => const Text('No se pudo cargar tareas.'),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Actividad reciente',
              child: activitiesState.when(
                data: (items) => Column(
                  children: items
                      .take(3)
                      .map(
                        (activity) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(activity.summary),
                          subtitle: Text(
                            '${activity.type} • ${activity.owner}',
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
                loading: () => const _LoadingCard(height: 120),
                error: (_, _) => const Text('No se pudo cargar actividades.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        _MetricCard(label: 'Clientes', value: '${summary.totalCustomers}'),
        _MetricCard(label: 'Leads activos', value: '${summary.activeLeads}'),
        _MetricCard(label: 'Pipeline', value: _currency(summary.pipelineValue)),
        _MetricCard(label: 'Tareas abiertas', value: '${summary.openTasks}'),
        _MetricCard(
          label: 'Ganado mes',
          value: _currency(summary.wonThisMonth),
        ),
        _MetricCard(
          label: 'Conversion',
          value: '${(summary.conversionRate * 100).toStringAsFixed(0)}%',
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
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
          .take(4)
          .map(
            (task) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(task.title),
              subtitle: Text('${task.type} • ${task.dueDate}'),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () async {
                  await ref
                      .read(tasksControllerProvider.notifier)
                      .complete(task.id);
                },
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
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
