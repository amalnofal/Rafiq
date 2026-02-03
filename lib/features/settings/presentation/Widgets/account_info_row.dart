import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class AccountInfoRow extends StatelessWidget {
  const AccountInfoRow({
    super.key,
    required this.label,
    this.value,
    this.direction,
    this.padding,
  });

  final String label;
  final String? value;
  final TextDirection? direction;
  final double? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: padding ?? AppDimensions.paddingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          Text(
            value ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
            textDirection: direction,
            textAlign: direction == TextDirection.ltr ? TextAlign.left : null,
          ),
        ],
      ),
    );
  }
}
