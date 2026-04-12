import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.black,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: AppColors.blackSoft,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
              child: Row(
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
                  const SizedBox(width: 8),
                  const Text(
                    'Contactos',
                    style: TextStyle(
                      color: AppColors.textOnDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const <Widget>[
                    _SimpleCard(
                      title: 'Carlos Mendez',
                      subtitle: 'ABC Corp · carlos@abccorp.com',
                    ),
                    _SimpleCard(
                      title: 'Laura Salinas',
                      subtitle: 'Logging Adventures · laura@logging.com',
                    ),
                    _SimpleCard(
                      title: 'Diego Carranza',
                      subtitle: 'XYZ Limited · diego@xyz.com',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  const _SimpleCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8EA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Color(0xFF666A70))),
        ],
      ),
    );
  }
}
