import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/features/collar/data/models/collar_model.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetStatsRow extends StatelessWidget {
  final CollarModel collar;

  const PetStatsRow({super.key, required this.collar});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppDimensions.padding),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
          width: 1.w,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // النبض
            _buildStatItem(
              context: context,
              title: AppLocalizations.of(context)!.pulse,
              // value: "${collar.heartRate}",
              iconPath: "assets/icons/heart.svg",
              value: "82",
            ),

            // الخط الفاصل
            VerticalDivider(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              thickness: 1.5,
              width: 1.w,
            ),

            // الحرارة
            _buildStatItem(
              context: context,
              title: AppLocalizations.of(context)!.temperature,
              // value: "${collar.temp}°",
              iconPath: "assets/icons/temp.svg",
              value: "38.2°",
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
        CircleIconButton(iconPath, size: 48.w, iconSize: 24.w),
        SizedBox(width: 12.w),
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
      ],
    );
  }
}
