import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/segmented_circular_indicator.dart';

class HeartRateDetailedCard extends StatelessWidget {
  const HeartRateDetailedCard({super.key});

  final List<double> _barHeights = const [39, 38, 39, 41, 37, 40, 36, 33, 31];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        children: [
          // 1. الدائرة والأرقام
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleIconButton(
                    "assets/icons/heart.svg",
                    color: Color(0xFFFB2C36),
                    size: 40.h,
                    iconSize: 20.h,
                    bgColor: isDarkMode
                        ? Color(0xffFB2C36).withValues(alpha: 0.1)
                        : Color(0xFFFEF2F2),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.heartRate,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            "82",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(fontSize: 20.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "bpm",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              Stack(
                alignment: Alignment.center,
                children: [
                  // SizedBox(
                  //   width: 50.w,
                  //   height: 50.w,
                  //   child: CircularProgressIndicator(
                  //     value: 0.6,
                  //     strokeWidth: 6,
                  //     color: isDarkMode ? Color(0xFFE63946) : Color(0xFFEF4444),
                  //     backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  //     strokeCap: StrokeCap.round,
                  //   ),
                  // ),
                  const SegmentedCircularIndicator(
                    progress: 0.6, // نسبة 60%
                  ),
                  Text("68%", style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // 2. الرسم البياني
          SizedBox(
            height: 48.h,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_barHeights.length, (index) {
                    return Expanded(
                      child: Container(
                        height: (_barHeights[index] * value).h,
                        margin: EdgeInsets.only(
                          right: index == _barHeights.length - 1 ? 0 : 4.w,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Color(0xFFFB2C36).withValues(alpha: 0.2)
                              : Color(0xFFFFE2E2),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4.r),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
