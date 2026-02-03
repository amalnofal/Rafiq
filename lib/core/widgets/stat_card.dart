import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title, this.bgcolor, this.color});
  final String title;
  final Color? bgcolor;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: bgcolor ?? Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Text(
        title,
        style: AppTextStyles.bodySmall(
          color: color ?? Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}
