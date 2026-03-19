import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/opportunity.dart';
import '../providers/opportunities_providers.dart';

class PipelinePage extends ConsumerWidget {
  const PipelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesState = ref.watch(opportunitiesControllerProvider);

    return SafeArea(
      child: opportunitiesState.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(opportunitiesControllerProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(
                'Pipeline comercial',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Mueve oportunidades entre etapas (mock API)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OpportunityCard(opportunity: item),
                ),
              ),
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

class _OpportunityCard extends ConsumerWidget {
  const _OpportunityCard({required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              opportunity.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              opportunity.customerName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    NumberFormat.currency(
                      locale: 'es_MX',
                      symbol: '\$',
                    ).format(opportunity.amount),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text('${(opportunity.probability * 100).toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<OpportunityStage>(
              initialValue: opportunity.stage,
              decoration: const InputDecoration(
                labelText: 'Etapa',
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
          ],
        ),
      ),
    );
  }
}
