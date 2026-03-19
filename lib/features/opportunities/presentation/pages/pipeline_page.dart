import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/crm_page_shell.dart';
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

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Etapa actualizada en mock API.'),
                    ),
                  );
                }
              },
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
