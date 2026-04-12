import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F3),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const <Widget>[
            Text(
              'Contactos',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2A2C2F),
              ),
            ),
            SizedBox(height: 10),
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
