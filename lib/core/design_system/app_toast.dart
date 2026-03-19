import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppToast {
  const AppToast._();

  static void success(BuildContext context, String message) {
    _show(context, message, Icons.check_circle_rounded);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, Icons.info_outline_rounded);
  }

  static void _show(BuildContext context, String message, IconData icon) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.black,
        content: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.yellow, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
