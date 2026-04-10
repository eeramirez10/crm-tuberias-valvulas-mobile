import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/customer.dart';
import '../providers/customers_providers.dart';

class CustomerDetailsPage extends ConsumerStatefulWidget {
  const CustomerDetailsPage({super.key, required this.customerId});

  final String customerId;

  @override
  ConsumerState<CustomerDetailsPage> createState() =>
      _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends ConsumerState<CustomerDetailsPage> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customersProvider());

    return Scaffold(
      backgroundColor: AppColors.black,
      body: customerState.when(
        data: (customers) {
          final customer = _findCustomer(customers, widget.customerId);
          if (customer == null) {
            return const Center(
              child: Text(
                'Cliente no encontrado',
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
                          'Client Details',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: AppColors.textOnDark),
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
                              customer.contactName.substring(0, 1),
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
                                  customer.contactName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  '${customer.contactName.toLowerCase().replaceAll(' ', '.')}@${customer.name.toLowerCase().split(' ').first}.com',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                const SizedBox(height: 2),
                                Text(customer.name),
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
                              customer.creditStatus.toUpperCase(),
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
                  decoration: const BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.panelCard,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppColors.panelBorder),
                        ),
                        child: Row(
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
                                label: 'Projects',
                                onTap: () => setState(() => tab = 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (tab == 0)
                        _OverviewCard(customer: customer)
                      else
                        _ProjectsCard(customer: customer),
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

  Customer? _findCustomer(List<Customer> customers, String id) {
    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _Field(
              label: 'Email',
              value:
                  '${customer.contactName.toLowerCase().replaceAll(' ', '.')}@empresa.com',
            ),
            _Field(label: 'Phone', value: customer.contactPhone),
            _Field(label: 'Company', value: customer.name),
            _Field(label: 'City', value: customer.city),
            if (customer.industrialSector.isNotEmpty)
              _Field(
                label: 'Giro industrial',
                value: customer.industrialSector,
              ),
            if (customer.projectState.isNotEmpty ||
                customer.projectCity.isNotEmpty)
              _Field(
                label: 'Ubicacion proyecto',
                value:
                    '${customer.projectCity.isEmpty ? 'N/D' : customer.projectCity}, ${customer.projectState.isEmpty ? 'N/D' : customer.projectState}',
              ),
            _Field(label: 'Estatus credito', value: customer.creditStatus),
          ],
        ),
      ),
    );
  }
}

class _ProjectsCard extends StatelessWidget {
  const _ProjectsCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final widgets = <({IconData icon, String value, String label})>[
      (
        icon: Icons.work,
        value: '${customer.id.hashCode.abs() % 6 + 1}',
        label: 'Projects',
      ),
      (
        icon: Icons.receipt_long,
        value: '${customer.id.hashCode.abs() % 14 + 4}',
        label: 'Invoices',
      ),
      (icon: Icons.attach_money, value: '\$78.0K', label: 'Revenue'),
      (icon: Icons.trending_up, value: '\$6.5K', label: 'Avg ticket'),
    ];

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
              children: widgets
                  .map(
                    (item) => Container(
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
                          Icon(item.icon, color: AppColors.black),
                          const SizedBox(height: 10),
                          Text(
                            item.value,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            item.label,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
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
