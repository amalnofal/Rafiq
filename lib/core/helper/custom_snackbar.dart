import 'package:flutter/material.dart';

class CustomSnackBar {
  /// يعرض Snackbar بسيط بألوان الثيم
  static void show(BuildContext context, {required String message}) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.primaryContainer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onPrimary,
          ), // يتغير تلقائي مع الثيم
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
