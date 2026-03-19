import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../domain/entities/customer.dart';
import '../providers/customers_providers.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersState = ref.watch(customersProvider());

    return CrmPageShell(
      title: 'Clients',
      subtitle: 'Cuentas activas',
      actions: <Widget>[
        ActionSquare(
          icon: Icons.refresh_rounded,
          onTap: () => ref.invalidate(customersProvider()),
        ),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.search_rounded, onTap: () {}),
      ],
      child: customersState.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(customersProvider());
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const SizedBox(height: 8),
              ...items.map(
                (customer) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CustomerCard(customer: customer),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Error cargando clientes: $error')),
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final estimatedRevenue = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
    ).format((customer.id.hashCode.abs() % 200 + 40) * 1000);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push('/customers/${customer.id}'),
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
                    child: const Icon(Icons.business_rounded),
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
                          customer.name,
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
                      customer.creditStatus.toUpperCase(),
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
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text('${customer.city} • ${customer.segment}'),
                  const Spacer(),
                  Text(
                    estimatedRevenue,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
