import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class AccountInfoRow extends StatelessWidget {
  const AccountInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.direction,
  });

  final String label;
  final String value;
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            textDirection: direction,
            textAlign: direction == TextDirection.ltr ? TextAlign.left : null,
          ),
        ],
      ),
    );
  }
}
