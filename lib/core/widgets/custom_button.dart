import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.fontWeight,
    this.fontSize,
    this.iconSize,
    this.color,
    this.txtColor,
    this.onPressed,
    this.icon,
    this.iconColor,
    this.height,
    this.width,
    this.preserveIconColors = false,
    this.elevation = 4,
    this.hasBorder = false,
    this.radius,
  });

  final String title;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? iconSize;
  final Color? color;
  final Color? txtColor;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final String? icon;
  final double? height;
  final double? width;
  final double? elevation;
  final bool preserveIconColors;
  final bool hasBorder;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = height ?? AppDimensions.buttonHeight;
    final double buttonWidth = width ?? double.infinity;

    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          padding: WidgetStateProperty.all(EdgeInsets.zero),

          minimumSize: WidgetStateProperty.all(
            Size(
              buttonWidth == double.infinity ? 0 : buttonWidth,
              buttonHeight,
            ),
          ),

          alignment: Alignment.center,
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            Color baseColor = color ?? Theme.of(context).colorScheme.primary;
            if (states.contains(WidgetState.disabled)) {
              return baseColor.withValues(alpha: 0.5);
            }
            return baseColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            Color baseColor =
                txtColor ?? Theme.of(context).colorScheme.onPrimary;
            if (states.contains(WidgetState.disabled)) {
              return baseColor.withValues(alpha: 0.7);
            }
            return baseColor;
          }),

          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return 0;
            }
            return elevation;
          }),

          shadowColor: WidgetStateProperty.all(AppColors.kShadowOverlay),

          side: hasBorder
              ? WidgetStateProperty.all(
                  BorderSide(color: Theme.of(context).dividerColor, width: 1),
                )
              : null,

          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 16.r),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SvgPicture.asset(
                icon!,
                height: iconSize ?? 24.h,
                width: 24.w,
                colorFilter: preserveIconColors
                    ? null
                    : ColorFilter.mode(
                        iconColor ?? Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
              ),
              SizedBox(width: 12.w),
            ],
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: fontWeight,
                    fontSize: fontSize ?? 16.sp,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
