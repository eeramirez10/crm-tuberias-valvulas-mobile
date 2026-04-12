import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F3),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const <Widget>[
            Text(
              'Usuarios',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2A2C2F),
              ),
            ),
            SizedBox(height: 10),
            _UserCard(name: 'Erick Ramirez', role: 'Administrador'),
            _UserCard(name: 'Mariana Solis', role: 'Gerente comercial'),
            _UserCard(name: 'Rafael Ortega', role: 'Vendedor'),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.name, required this.role});

  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8EA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: Color(0xFF707A82),
            child: Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(role, style: const TextStyle(color: Color(0xFF666A70))),
              ],
            ),
          ),
          const Icon(Icons.more_horiz_rounded),
        ],
      ),
    );
  }
}
