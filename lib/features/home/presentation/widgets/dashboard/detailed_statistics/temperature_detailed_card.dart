import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/stat_card.dart';

class TemperatureDetailedCard extends StatelessWidget {
  final double temperature;
  const TemperatureDetailedCard({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // حالة وهمية لتحديد النص (طبيعي ولا مرتفع)
    String statusText = temperature > 39.0
        ? context.l10n.high
        : (temperature < 37.5 ? context.l10n.low : context.l10n.normal);

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
                            "${temperature.toStringAsFixed(1)}°",
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
              StatCard(title: statusText),
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
    final textDirection = Directionality.of(context);

    const double minTemp = 36.0;
    const double maxTemp = 41.0;

    // التأكد إذا كان في قراءة حقيقية ولا لسه (0.0)
    bool hasReading = temperature > 0.0;
    double percent = 0.0;

    if (hasReading) {
      percent = (temperature - minTemp) / (maxTemp - minTemp);
      percent = percent.clamp(0.0, 1.0);
    }

    return Column(
      children: [
        SizedBox(
          height: 20.h,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;
              // حساب مكان المؤشر (بنطرح عرض المؤشر عشان ميطلعش بره الشاشة)
              double indicatorPosition = percent * (maxWidth - 4.w);

              return Stack(
                alignment: Alignment.center,
                children: [
                  // 1. شريط الألوان
                  Container(
                    height: 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: hasReading ? null : Colors.grey.shade300,
                      gradient: hasReading
                          ? const LinearGradient(
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd,
                              colors: [
                                Color(0xFF51A2FF), // أزرق
                                Color(0xFF05DF72), // أخضر
                                Color(0xFFFF6467), // أحمر
                              ],
                            )
                          : null,
                    ),
                  ),

                  // 2. إبرة المؤشر (تظهر فقط لو في قراءة)
                  if (hasReading)
                    Positioned.directional(
                      textDirection: textDirection,
                      start: indicatorPosition,
                      child: Container(
                        width: 4.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          borderRadius: BorderRadius.circular(2.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 6.h),

        // 3. مسطرة التدرج (Ticks & Scale)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // List.generate بتعملنا 6 أرقام (من 36 لـ 41) بينهم مسافات متساوية
          children: List.generate(6, (index) {
            int val = 36 + index;
            return Column(
              children: [
                // علامة المسطرة (الشرطة الصغيرة)
                Container(
                  width: 1.5.w,
                  height: 4.h,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                SizedBox(height: 2.h),
                // الرقم
                Text("$val°", style: Theme.of(context).textTheme.labelSmall),
              ],
            );
          }),
        ),
      ],
    );
  }
}
