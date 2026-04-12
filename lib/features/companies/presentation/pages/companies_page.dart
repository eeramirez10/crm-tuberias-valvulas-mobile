import 'package:flutter/material.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF64737D);
    const bodyColor = Color(0xFFF0F1F3);
    final companies = <_CompanyItem>[
      const _CompanyItem(
        name: 'ABC Corp',
        subtitle: 'Main User · Contact',
        icon: Icons.account_tree_rounded,
        iconColor: Color(0xFFC03995),
      ),
      const _CompanyItem(
        name: 'Logging Adventures',
        subtitle: 'Main User',
        icon: Icons.hexagon_rounded,
        iconColor: Color(0xFFF6A72E),
      ),
      const _CompanyItem(
        name: 'Madeup Company',
        subtitle: 'User 2',
        icon: Icons.tune_rounded,
        iconColor: Color(0xFFF39C12),
      ),
      const _CompanyItem(
        name: 'New Corp',
        subtitle: 'User 2',
        icon: Icons.lightbulb_rounded,
        iconColor: Color(0xFFE74C3C),
      ),
      const _CompanyItem(
        name: 'XYZ Limited',
        subtitle: 'Main User',
        icon: Icons.tv_rounded,
        iconColor: Color(0xFF7D3CDB),
      ),
    ];

    return Scaffold(
      backgroundColor: bodyColor,
      body: SafeArea(
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
                            color: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'All Companies',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40 * 0.86,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF5D6870),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          'New Company',
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
                            fillColor: Colors.white.withValues(alpha: 0.16),
                            hintText: 'Buscar',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Colors.white,
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
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.filter_list_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
                      color: const Color(0xFFE7E8EA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
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
                          icon: const Icon(Icons.more_horiz_rounded),
                        ),
                      ],
                    ),
                  );
                },
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
