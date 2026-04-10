import 'package:crm_tuberias_valvulas_mobile/core/design_system/card_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/lead.dart';
import '../providers/leads_providers.dart';

class LeadDetailsPage extends ConsumerStatefulWidget {
  const LeadDetailsPage({super.key, required this.leadId});

  final String leadId;

  @override
  ConsumerState<LeadDetailsPage> createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends ConsumerState<LeadDetailsPage> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final leadsState = ref.watch(leadsProvider());

    return Scaffold(
      backgroundColor: AppColors.black,
      body: leadsState.when(
        data: (leads) {
          final lead = _findLead(leads, widget.leadId);
          if (lead == null) {
            return const Center(
              child: Text(
                'Lead no encontrado',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 5,
                  16,
                  20,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[AppColors.yellow, AppColors.yellowSoft],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Lead Details',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: AppColors.black),
                        ),
                        const Spacer(),
                        const Icon(Icons.edit_rounded),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.34),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child: Text(
                              _leadDisplayName(lead).substring(0, 1),
                              style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _leadDisplayName(lead),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: AppColors.black),
                                ),
                                Text(
                                  _leadEmail(lead),
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lead.companyName,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(10),
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
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: AppColors.panel),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _TabButton(
                              active: tab == 0,
                              label: 'Overview',
                              onTap: () => setState(() => tab = 0),
                            ),
                          ),
                          Expanded(
                            child: _TabButton(
                              active: tab == 1,
                              label: 'Analytics',
                              onTap: () => setState(() => tab = 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (tab == 0)
                        CardApp(child: _OverviewCard(lead: lead))
                      else
                        _AnalyticsCard(lead: lead),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Lead? _findLead(List<Lead> leads, String id) {
    for (final lead in leads) {
      if (lead.id == id) {
        return lead;
      }
    }
    return null;
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        _Field(label: 'Email', value: _leadEmail(lead)),
        _Field(label: 'Phone', value: _leadPhone(lead)),
        _Field(label: 'Company', value: lead.companyName),
        if (lead.industrialSector.isNotEmpty)
          _Field(label: 'Giro industrial', value: lead.industrialSector),
        if (lead.creditStatus.isNotEmpty)
          _Field(label: 'Estatus credito', value: lead.creditStatus),
        if (lead.projectState.isNotEmpty || lead.projectCity.isNotEmpty)
          _Field(
            label: 'Ubicacion proyecto',
            value:
                '${lead.projectCity.isEmpty ? 'N/D' : lead.projectCity}, ${lead.projectState.isEmpty ? 'N/D' : lead.projectState}',
          ),
        if (lead.requiredDeliveryTime.isNotEmpty)
          _Field(
            label: 'Tiempo entrega requerido',
            value: lead.requiredDeliveryTime,
          ),
        if (lead.mainCompetitor.isNotEmpty)
          _Field(label: 'Competidor', value: lead.mainCompetitor),
        _Field(label: 'Source', value: lead.source),
        _Field(label: 'Next Action', value: lead.nextActionDate),
        if (lead.notes.isNotEmpty) _Field(label: 'Notas', value: lead.notes),
      ],
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
    ).format(lead.estimatedAmount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Business Summary',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _MetricBox(
                  icon: Icons.payments,
                  value: currency,
                  label: 'Valor estimado',
                ),
                _MetricBox(
                  icon: Icons.event_available,
                  value: lead.nextActionDate,
                  label: 'Follow up',
                ),
                _MetricBox(
                  icon: Icons.check_circle,
                  value: lead.status,
                  label: 'Estado',
                ),
                _MetricBox(
                  icon: Icons.support_agent,
                  value: '3',
                  label: 'Interacciones',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.sizeOf(context).width - 56) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.black),
          const SizedBox(height: 10),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 108,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.active,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: active ? AppColors.black : Colors.black54,
          ),
        ),
      ),
    );
  }
}

String _leadDisplayName(Lead lead) {
  final candidate = lead.contactName.isEmpty ? lead.owner : lead.contactName;
  if (candidate.isEmpty) {
    return 'Contacto';
  }
  return candidate;
}

String _leadEmail(Lead lead) {
  if (lead.contactEmail.isNotEmpty) {
    return lead.contactEmail;
  }
  return '${lead.companyName.toLowerCase().replaceAll(' ', '.')}@empresa.com';
}

String _leadPhone(Lead lead) {
  return lead.contactPhone.isEmpty ? 'Sin telefono' : lead.contactPhone;
}
