import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../domain/entities/lead.dart';
import '../providers/leads_providers.dart';

class LeadsPage extends ConsumerWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsState = ref.watch(leadsProvider());

    return CrmPageShell(
      title: 'Leads',
      subtitle: 'Leads asignados',
      actions: <Widget>[
        ActionSquare(icon: Icons.search_rounded, onTap: () {}),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.bar_chart_rounded, onTap: () {}),
      ],
      child: leadsState.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(leadsProvider());
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const SizedBox(height: 8),
              _LeadFilters(items: items),
              const SizedBox(height: 12),
              ...items.map(
                (lead) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _LeadCard(lead: lead),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Error cargando leads: $error')),
      ),
    );
  }
}

class _LeadFilters extends StatelessWidget {
  const _LeadFilters({required this.items});

  final List<Lead> items;

  @override
  Widget build(BuildContext context) {
    final byStatus = <String, int>{};
    for (final item in items) {
      byStatus[item.status] = (byStatus[item.status] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            Chip(
              label: Text('All (${items.length})'),
              backgroundColor: AppColors.yellow,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
            ...byStatus.entries.map(
              (entry) => Chip(
                label: Text('${entry.key} (${entry.value})'),
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.panelBorder),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  const _LeadCard({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
    ).format(lead.estimatedAmount);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push('/leads/${lead.id}'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person_add_alt_1_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          lead.owner,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lead.companyName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      lead.status.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.source_outlined,
                    size: 18,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Fuente: ${lead.source}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const Spacer(),
                  Text(
                    amount,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Icon(Icons.schedule, size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text('Follow up: ${lead.nextActionDate}'),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
