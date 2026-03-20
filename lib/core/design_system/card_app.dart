import 'package:crm_tuberias_valvulas_mobile/core/design_system/app_colors.dart';
import 'package:flutter/material.dart';

class CardApp extends StatelessWidget {

  final Widget child;

  const CardApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panelCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(padding: EdgeInsetsGeometry.all(14),
        child:child
      ),
    );
  }
}
