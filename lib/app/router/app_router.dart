import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/design_system/app_colors.dart';
import '../../features/ai_assistant/presentation/pages/ai_assistant_page.dart';
import '../../features/customers/presentation/pages/customer_details_page.dart';
import '../../features/customers/presentation/pages/customers_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/leads/presentation/pages/lead_details_page.dart';
import '../../features/leads/presentation/pages/leads_page.dart';
import '../../features/opportunities/presentation/pages/pipeline_page.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ShellScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/leads',
                builder: (context, state) => const LeadsPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':leadId',
                    builder: (context, state) {
                      final leadId = state.pathParameters['leadId'] ?? '';
                      return LeadDetailsPage(leadId: leadId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/pipeline',
                builder: (context, state) => const PipelinePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/customers',
                builder: (context, state) => const CustomersPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':customerId',
                    builder: (context, state) {
                      final customerId =
                          state.pathParameters['customerId'] ?? '';
                      return CustomerDetailsPage(customerId: customerId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/ai',
                builder: (context, state) => const AiAssistantPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goTo(int index, BuildContext context) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      drawer: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.83,
        backgroundColor: AppColors.panel,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(34),
            bottomRight: Radius.circular(34),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[AppColors.blackSoft, AppColors.black],
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Menu',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.yellow),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 34,
                          backgroundColor: AppColors.yellow,
                          child: Icon(
                            Icons.person,
                            size: 36,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text(
                              'Erick Ramirez',
                              style: TextStyle(
                                color: AppColors.textOnDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Supervisor comercial',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Tuvansa CRM',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Navegacion',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      _MenuTile(
                        selected: navigationShell.currentIndex == 0,
                        icon: Icons.dashboard_rounded,
                        label: 'Dashboard',
                        onTap: () => _goTo(0, context),
                      ),
                      const SizedBox(height: 8),
                      _MenuTile(
                        selected: navigationShell.currentIndex == 1,
                        icon: Icons.trending_up_rounded,
                        label: 'Leads',
                        onTap: () => _goTo(1, context),
                      ),
                      const SizedBox(height: 8),
                      _MenuTile(
                        selected: navigationShell.currentIndex == 2,
                        icon: Icons.handshake_rounded,
                        label: 'Deals',
                        onTap: () => _goTo(2, context),
                      ),
                      const SizedBox(height: 8),
                      _MenuTile(
                        selected: navigationShell.currentIndex == 3,
                        icon: Icons.business_rounded,
                        label: 'Clients',
                        onTap: () => _goTo(3, context),
                      ),
                      const SizedBox(height: 8),
                      _MenuTile(
                        selected: navigationShell.currentIndex == 4,
                        icon: Icons.auto_awesome_rounded,
                        label: 'Asistente IA',
                        onTap: () => _goTo(4, context),
                      ),
                      const Spacer(),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      const ListTile(
                        dense: true,
                        leading: Icon(Icons.info_outline),
                        title: Text('CRM v1.0.0'),
                        subtitle: Text('Demo amarillo/negro'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          foregroundColor: AppColors.black,
                          side: const BorderSide(color: AppColors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar menu'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: navigationShell,
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.yellow : Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.black
                      : AppColors.yellow.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: selected ? AppColors.yellow : AppColors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.black),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.black),
            ],
          ),
        ),
      ),
    );
  }
}
