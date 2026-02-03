import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/custom_button.dart';

class AppleButton extends StatelessWidget {
  const AppleButton({super.key, required this.title, required this.onPressed});
  final String title;
    final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      title: title,
      color: const Color(0xFF000000),
      icon: "assets/icons/apple.svg",
      iconColor: const Color(0XFFFFFFFF),
      txtColor: const Color(0XFFFFFFFF),
      elevation: 4,
      onpressed: onPressed
    );
  }
}
