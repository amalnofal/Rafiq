import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/enums/post_category.dart';

class InterestCard extends StatelessWidget {
  const InterestCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.showError,
    required this.onTap,
  });

  final PostCategory category;
  final bool isSelected;
  final bool showError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : (showError ? Colors.red : theme.colorScheme.outline);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          border: Border.all(color: borderColor, width: 1.5.w),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Text(category.icon, style: TextStyle(fontSize: 24.sp)),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              category.getLabel(context),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge!.copyWith(fontSize: 15.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            Text(
              category.getSubtitle(context),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
