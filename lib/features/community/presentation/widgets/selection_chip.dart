import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isSmall;

  const SelectionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isSmall
            ? EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ) // حجم صغير للبوست
            : EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ), // حجم كبير للاختيار
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(
                  context,
                ).colorScheme.surfaceContainer.withValues(alpha: 0.2)
              : Theme.of(context).cardTheme.color,

          borderRadius: BorderRadius.circular(20.r),

          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  width: 1.5.w,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: isSmall ? 12.sp : 16.sp)),
            SizedBox(width: isSmall ? 4.w : 8.w),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                label,
                style: isSmall
                    ? Theme.of(context).textTheme.labelSmall
                    : Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
