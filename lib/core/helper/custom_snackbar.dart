import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final theme = Theme.of(context);
  final backgroundColor = theme.colorScheme.primary;
  final errorColor = theme.colorScheme.error;
  final messageColor = theme.colorScheme.onPrimary;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(color: messageColor),
      ),
      // behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? errorColor : backgroundColor,
      duration: const Duration(seconds: 3),
    ),
  );
}
