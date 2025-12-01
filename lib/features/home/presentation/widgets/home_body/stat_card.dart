import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // إضافة مكتبة SVG
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // عرض ثابت مناسب ليكون هناك 3 كروت بجانب بعضهم
      width: 100.w,
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingM,
        horizontal: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        // لون الخلفية البيج الفاتح (Surface Alt) حسب الديزاين
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة SVG
          SvgPicture.asset(
            icon,
            height: AppDimensions.iconL,
            width: AppDimensions.iconL,
          ),
          SizedBox(height: AppDimensions.paddingXS),

          // العنوان (النبض، النشاط...)
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.kContentSecondary, // لون نص ثانوي
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.paddingXS),

          // القيمة (82، 38.2...)
          Text(
            value,
            style: AppTextStyles.headlineMedium(
              color: AppColors.kContentPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
