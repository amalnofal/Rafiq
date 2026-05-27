import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';

class LocationDetailedCard extends StatelessWidget {
  const LocationDetailedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        children: [
          // الموقع
          Row(
            children: [
              CircleIconButton(
                "assets/icons/location.svg",
                color: Color(0xFF00C950),
                size: 40.h,
                iconSize: 20.h,
                bgColor: isDarkMode
                    ? Color(0xFF00C950).withValues(alpha: 0.1)
                    : Color(0xFFF0FDF4),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.currentLocation,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  Text(
                    "Damietta, New Damietta",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // الخريطة
          Container(
            height: 96.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF262626) : Color(0xFFF5F3ED),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/location.svg",
                height: 32.h,
                width: 32.h,
                colorFilter: ColorFilter.mode(
                  Color(0xFF00C950),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
