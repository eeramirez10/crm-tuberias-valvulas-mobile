import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/design_system/app_colors.dart';
import '../../features/companies/presentation/pages/companies_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/users/presentation/pages/users_page.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/empresas',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ShellScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/empresas',
                builder: (context, state) => const CompaniesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/contactos',
                builder: (context, state) => const ContactsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/usuarios',
                builder: (context, state) => const UsersPage(),
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
        backgroundColor: AppColors.blackSoft,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                18,
                MediaQuery.of(context).padding.top + 18,
                18,
                20,
              ),
              color: AppColors.black,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Menu',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.yellow,
                    ),
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
                  SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                children: <Widget>[
                  Text(
                    'Navegacion',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MenuTile(
                    selected: navigationShell.currentIndex == 0,
                    icon: Icons.apartment_rounded,
                    label: 'Empresas',
                    onTap: () => _goTo(0, context),
                  ),
                  const SizedBox(height: 8),
                  _MenuTile(
                    selected: navigationShell.currentIndex == 1,
                    icon: Icons.contact_phone_rounded,
                    label: 'Contactos',
                    onTap: () => _goTo(1, context),
                  ),
                  const SizedBox(height: 8),
                  _MenuTile(
                    selected: navigationShell.currentIndex == 2,
                    icon: Icons.group_rounded,
                    label: 'Usuarios',
                    onTap: () => _goTo(2, context),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Colors.white24),
                  const SizedBox(height: 10),
                  const ListTile(
                    dense: true,
                    leading: Icon(Icons.info_outline, color: AppColors.yellow),
                    title: Text(
                      'CRM v1.0.0',
                      style: TextStyle(color: AppColors.textOnDark),
                    ),
                    subtitle: Text(
                      'Tema Tuvansa',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      foregroundColor: AppColors.yellow,
                      side: const BorderSide(color: AppColors.yellow),
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
          ],
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
                      : AppColors.yellow.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: selected ? AppColors.yellow : AppColors.yellow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: selected ? AppColors.black : AppColors.textOnDark,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: selected ? AppColors.black : AppColors.yellow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
