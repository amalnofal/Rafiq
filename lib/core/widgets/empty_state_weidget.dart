import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class EmptyStateWidget extends StatelessWidget {
  final String iconPath; 
  final String title;    
  final double? iconSize;  

  const EmptyStateWidget({
    super.key,
    required this.iconPath,
    required this.title,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140.r,
              height: 140.r,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              // الايقونة داخل الدائرة
              child: Center(
                child: SvgPicture.asset(
                  iconPath, 
                  width: iconSize ?? 70.w,
                  height: iconSize ?? 70.h,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // العنوان الأساسي
            Text(
              title, 
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 8.h),

            // النص الفرعي
            Text(
              context.l10n.checkBackLater, 
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}