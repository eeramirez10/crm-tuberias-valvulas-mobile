import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../domain/entities/opportunity.dart';
import '../providers/opportunities_providers.dart';

class PipelinePage extends ConsumerWidget {
  const PipelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesState = ref.watch(opportunitiesControllerProvider);

    return CrmPageShell(
      title: 'Deals',
      subtitle: '2 oportunidades asignadas',
      actions: <Widget>[
        ActionSquare(icon: Icons.search_rounded, onTap: () {}),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.bar_chart_rounded, onTap: () {}),
      ],
      child: opportunitiesState.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(opportunitiesControllerProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const SizedBox(height: 8),
              _StageStrip(items: items),
              const SizedBox(height: 12),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OpportunityCard(opportunity: item),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Error cargando pipeline: $error')),
      ),
    );
  }
}

class _StageStrip extends StatelessWidget {
  const _StageStrip({required this.items});

  final List<Opportunity> items;

  @override
  Widget build(BuildContext context) {
    final countByStage = <OpportunityStage, int>{
      for (final stage in OpportunityStage.values) stage: 0,
    };

    for (final item in items) {
      countByStage[item.stage] = (countByStage[item.stage] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.panelCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: OpportunityStage.values
            .take(4)
            .map(
              (stage) => Chip(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.panelBorder),
                avatar: CircleAvatar(
                  backgroundColor: AppColors.yellow,
                  child: Text(
                    '${countByStage[stage]}',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                label: Text(stage.label),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _OpportunityCard extends ConsumerWidget {
  const _OpportunityCard({required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        opportunity.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        opportunity.customerName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'es_MX',
                    symbol: '\$',
                  ).format(opportunity.amount),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: opportunity.probability,
                    backgroundColor: Colors.black12,
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${(opportunity.probability * 100).toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<OpportunityStage>(
              initialValue: opportunity.stage,
              decoration: const InputDecoration(
                labelText: 'Etapa comercial',
                border: OutlineInputBorder(),
              ),
              items: OpportunityStage.values
                  .map(
                    (stage) => DropdownMenuItem<OpportunityStage>(
                      value: stage,
                      child: Text(stage.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (selected) async {
                if (selected == null || selected == opportunity.stage) {
                  return;
                }

                await ref
                    .read(opportunitiesControllerProvider.notifier)
                    .moveToStage(
                      opportunityId: opportunity.id,
                      stage: selected,
                    );
                await ref
                    .read(activitiesTimelineControllerProvider.notifier)
                    .logInteraction(
                      type: 'Pipeline',
                      summary:
                          'Etapa cambiada manualmente a ${selected.label} para ${opportunity.title}.',
                    );

                if (context.mounted) {
                  AppToast.success(context, 'Etapa actualizada en mock API.');
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
                  onPressed: () async {
                    final next = _nextStage(opportunity.stage);
                    await ref
                        .read(opportunitiesControllerProvider.notifier)
                        .moveToStage(
                          opportunityId: opportunity.id,
                          stage: next,
                        );
                    await ref
                        .read(activitiesTimelineControllerProvider.notifier)
                        .logInteraction(
                          type: 'Pipeline',
                          summary:
                              'Oportunidad ${opportunity.title} movida a ${next.label}.',
                        );
                    if (context.mounted) {
                      AppToast.success(
                        context,
                        'Etapa movida a ${next.label}.',
                      );
                    }
                  },
                  icon: const Icon(Icons.trending_up_rounded, size: 18),
                  label: const Text('Mover +1 etapa'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.black),
                    foregroundColor: AppColors.black,
                  ),
                  onPressed: () async {
                    await ref
                        .read(tasksControllerProvider.notifier)
                        .createFollowUpTask(
                          title: 'Seguimiento oportunidad ${opportunity.title}',
                          type: 'Seguimiento',
                          dueDate: opportunity.expectedCloseDate,
                          relatedTo: opportunity.id,
                        );
                    await ref
                        .read(activitiesTimelineControllerProvider.notifier)
                        .logInteraction(
                          type: 'Tarea',
                          summary:
                              'Seguimiento creado para oportunidad ${opportunity.title}.',
                        );
                    if (context.mounted) {
                      AppToast.success(context, 'Tarea de seguimiento creada.');
                    }
                  },
                  icon: const Icon(Icons.add_task_rounded, size: 18),
                  label: const Text('Crear tarea'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Cierre estimado: ${opportunity.expectedCloseDate}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

OpportunityStage _nextStage(OpportunityStage current) {
  final values = OpportunityStage.values;
  final index = values.indexOf(current);
  if (index == -1 || index == values.length - 1) {
    return current;
  }
  return values[index + 1];
}
