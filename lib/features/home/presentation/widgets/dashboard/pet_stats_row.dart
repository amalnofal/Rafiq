import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/controller/collar_provider.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetStatsRow extends StatelessWidget {
  const PetStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final reading = context.watch<CollarProvider>().latestReading;

    final String heartRate = reading != null
        ? reading.heartRateBpm.toString()
        : "--";
    final String temp = reading != null
        ? reading.temperatureCelsius.toStringAsFixed(1)
        : "--";

    return CustomContainer(
      margin: EdgeInsets.all(8.h),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // الحرارة
            _buildStatItem(
              context: context,
              title: AppLocalizations.of(context)!.temperature,
              iconPath: "assets/icons/temp.svg",
              value: "$temp°",
            ),
            // الخط الفاصل
            VerticalDivider(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              thickness: 1.5,
              width: 1.w,
            ),
            // النبض
            _buildStatItem(
              context: context,
              title: AppLocalizations.of(context)!.pulse,
              iconPath: "assets/icons/heart.svg",
              value: heartRate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String title,
    required String value,
    required String iconPath,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
        SizedBox(width: 12.w),
        CircleIconButton(iconPath, size: 48.w, iconSize: 24.w),
      ],
    );
  }
}
