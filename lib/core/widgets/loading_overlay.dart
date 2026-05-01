import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final Color? backgroundColor;

  final Color? indicatorColor;

  final double? indicatorSize;

  const LoadingOverlay({
    super.key,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withValues(alpha: 0.1),
      child: Center(
        child: SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(
              indicatorColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
