import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/widgets/custom_button.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.title, required this.onPressed});
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomButton(
      icon: "assets/icons/google.svg",
      title: title,
      color: Theme.of(context).colorScheme.secondary,
      txtColor: isDarkMode ? AppColors.kDarkContentPrimary : Color(0xFF2D3319),
      preserveIconColors: true,
      hasBorder: true,
      elevation: 1,
      onpressed:  onPressed,
    );
  }
}
