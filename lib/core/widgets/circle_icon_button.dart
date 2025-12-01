import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_colors.dart';

// ============================================================================
// CIRCLE ICON BUTTON - زر دائري للأيقونات
// ============================================================================

class CircleIconButton extends StatelessWidget {
  final String assetName;
  final Color? backgroundColor;
  final Color? color; // اختياري، لو حبيتي تغيّري لون أي أيقونة معينة
  final VoidCallback? onTap;
  final double? size;

  const CircleIconButton(
    this.assetName, {
    super.key,
    this.backgroundColor,
    this.color,
    this.onTap,
    this.size, // حجم الـ Container الدائري
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double size = this.size ?? 40.0.w;
    return InkWell(
      borderRadius: BorderRadius.circular(size / 2),
      onTap: onTap ?? () {},
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          // استخدم backgroundColor لو موجودة، وإلا استخدم لون الدائرة البيج من الثيم
          color:
              backgroundColor ??
              Theme.of(context).colorScheme.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            assetName,
            colorFilter: ColorFilter.mode(
              // استخدم color لو موجودة، وإلا استخدم اللون المناسب للأيقونات
              color ?? (isDark ? AppColors.kSurfaceAlt : AppColors.kBrandPrimary),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
