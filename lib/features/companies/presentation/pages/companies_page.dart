import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const headerColor = AppColors.blackSoft;
    const bodyColor = Color(0xFFF4F4F4);
    final companies = <_CompanyItem>[
      const _CompanyItem(
        name: 'ABC Corp',
        subtitle: 'Usuario principal · Contacto',
        icon: Icons.apartment_rounded,
        iconColor: AppColors.black,
      ),
      const _CompanyItem(
        name: 'Logging Ventures',
        subtitle: 'Usuario principal',
        icon: Icons.hub_rounded,
        iconColor: AppColors.black,
      ),
      const _CompanyItem(
        name: 'Madeup Company',
        subtitle: 'Usuario 2',
        icon: Icons.stacked_line_chart_rounded,
        iconColor: AppColors.black,
      ),
      const _CompanyItem(
        name: 'New Corp',
        subtitle: 'Usuario 2',
        icon: Icons.lightbulb_rounded,
        iconColor: AppColors.black,
      ),
      const _CompanyItem(
        name: 'XYZ Limited',
        subtitle: 'Usuario principal',
        icon: Icons.videocam_rounded,
        iconColor: AppColors.black,
      ),
    ];

    return ColoredBox(
      color: AppColors.black,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Container(
              color: headerColor,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: const Icon(Icons.menu_rounded),
                            color: AppColors.yellow,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Empresas',
                          style: TextStyle(
                            color: AppColors.textOnDark,
                            fontSize: 40 * 0.86,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: AppColors.black,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          'Nueva empresa',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.08),
                            hintText: 'Buscar',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.filter_list_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bodyColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE7E7E7)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.yellowSoft,
                            ),
                            child: Icon(company.icon, color: company.iconColor),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  company.name,
                                  style: const TextStyle(
                                    fontSize: 25 * 0.86,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF242628),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  company.subtitle,
                                  style: const TextStyle(
                                    color: Color(0xFF6C6E72),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_horiz_rounded,
                              color: Color(0xFF3A3A3A),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyItem {
  const _CompanyItem({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
}
