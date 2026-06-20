import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';

class UnlinkButton extends StatelessWidget {
  final double? btnHeight;
  final double? fontSize;
  final double? iconSize;
  final VoidCallback? onPressed;
  const UnlinkButton({
    super.key,
    this.fontSize,
    this.iconSize,
    this.btnHeight,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    return CustomButton(
      height: btnHeight,
      fontSize: fontSize,
      color: isDarkMode ? const Color(0xFF3F1D1D) : const Color(0xFFFEF2F2),
      title: context.l10n.unlinkCollar,
      fontWeight: FontWeight.w500,
      txtColor: AppColors.kContentWarning,
      icon: "assets/icons/unlink.svg",
      iconSize: iconSize ?? 20.sp,
      iconColor: AppColors.kContentWarning,
      elevation: 0,
      hasBorder: true,
      borderColor: AppColors.kContentWarning,
      onPressed: onPressed ?? () {},
    );
  }
}
