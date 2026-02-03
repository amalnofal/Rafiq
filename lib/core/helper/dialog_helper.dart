import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/cancel_button.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_button.dart';

class CustomInfoDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmBtnText;
  final VoidCallback onConfirm;
  final Color mainColor;
  final IconData icon;
  final Widget? content;

  const CustomInfoDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmBtnText,
    required this.onConfirm,
    this.mainColor = Colors.red,
    this.icon = Icons.warning_amber_rounded,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. الأيقونة
            CircleIconButton(
              'assets/icons/warning.svg',
              iconSize: 24.h,
              size: 60.h,
              color: mainColor,
              backgroundColor: mainColor.withValues(alpha: 0.1),
            ),
            SizedBox(height: AppDimensions.padding),

            // 2. النصوص
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppDimensions.paddingL),

            // 3. المحتوى الإضافي (زي الباسورد)
            if (content != null) ...[
              content!,
              SizedBox(height: AppDimensions.paddingL),
            ],

            // 4. الأزرار
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: confirmBtnText,
                    height: AppDimensions.buttonHeightS,
                    fontWeight: FontWeight.w500,
                    elevation: 0,
                    color: isDark
                        ? mainColor.withValues(alpha: 0.8)
                        : mainColor,
                    onpressed: onConfirm,
                  ),
                ),
                SizedBox(width: AppDimensions.paddingM),
                Expanded(child: CancelButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
