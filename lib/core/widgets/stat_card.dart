import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    this.bgcolor,
    this.color,
    this.icon,
  });

  final String title;
  final Color? bgcolor;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final contentColor =
        color ?? Theme.of(context).colorScheme.onTertiaryContainer;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: bgcolor ?? Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Icon(icon, size: 14.r, color: contentColor),
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: contentColor),
          ),
        ],
      ),
    );
  }
}
