import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  final Color? borderColor;
  final double borderWidth;
  final Color? color;
  final double? width;
  final Clip clipBehavior;

  const CustomContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.onTap,
    this.borderColor,
    this.borderWidth = 2,
    this.color,
    this.width,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        margin:
            margin ?? EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        padding: padding ?? EdgeInsets.all(AppDimensions.paddingL),
        clipBehavior: clipBehavior,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.secondary,

          borderRadius: BorderRadius.circular(AppDimensions.radius),

          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth)
              : null,

          boxShadow: isDarkMode
              ? []
              : const [
                  BoxShadow(
                    color: AppColors.kShadowOverlay,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: -2,
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}
