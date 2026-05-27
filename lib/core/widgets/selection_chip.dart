import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionChip extends StatelessWidget {
  final String label;
  final String? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isSmall;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool hasUnselectedBorder;
  final EdgeInsetsGeometry? customPadding;

  const SelectionChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    this.onTap,
    this.isSmall = false,
    this.selectedColor,
    this.unselectedColor,
    this.hasUnselectedBorder = false,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            customPadding ??
            (isSmall
                ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
                : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)),

        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ??
                        Theme.of(context).colorScheme.surfaceContainer)
                    .withValues(alpha: 0.2)
              : (unselectedColor ?? Theme.of(context).cardTheme.color),
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected
              ? Border.all(
                  color:
                      (selectedColor ??
                              Theme.of(context).colorScheme.surfaceContainer)
                          .withValues(alpha: 0.5),
                  width: 1.w,
                )
              : (hasUnselectedBorder
                    ? Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1.5.w,
                      )
                    : null),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && icon!.isNotEmpty) ...[
              Text(icon!, style: TextStyle(fontSize: isSmall ? 12.sp : 16.sp)),
              SizedBox(width: isSmall ? 4.w : 8.w),
            ],
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
