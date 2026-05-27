import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/stat_card.dart';

class TemperatureDetailedCard extends StatelessWidget {
  const TemperatureDetailedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // درجة الحرارة والأيقونة
              Row(
                children: [
                  CircleIconButton(
                    "assets/icons/temp.svg",
                    color: Color(0xFFFF6900),
                    size: 40.h,
                    iconSize: 20.h,
                    bgColor: isDarkMode
                        ? Color(0xFFFF6900).withValues(alpha: 0.1)
                        : Color(0xFFFFF7ED),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.temperatureDegree,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            "38.2°",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(fontSize: 20.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "C",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // الحالة
              StatCard(title: context.l10n.normal),
            ],
          ),

          SizedBox(height: 12.h),

          // 2. شريط الحرارة
          _buildTemperatureBar(context),
        ],
      ),
    );
  }

  // دالة صغيرة لبناء شريط الألوان
  Widget _buildTemperatureBar(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          height: 20.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF51A2FF), // أزرق
                        Color(0xFF05DF72), // أخضر
                        Color(0xFFFF6467), // أحمر
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 120.w, // ثبتناها زي ما إنتي عاملاها
                child: Container(
                  width: 4.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Color(0XFFF5F5F5) : Color(0xFF2D3319),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        // الأرقام تحت الشريط
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("39°", style: Theme.of(context).textTheme.labelSmall),
            Text("38°", style: Theme.of(context).textTheme.labelSmall),
            Text("37°", style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}
