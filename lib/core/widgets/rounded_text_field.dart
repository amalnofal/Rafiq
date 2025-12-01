import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller; // أصبح مطلوب
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextDirection? textDirection;

  const RoundedTextField({
    super.key,
    required this.controller, // لازم يتمريره
    this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        textDirection: textDirection,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: inputTheme.filled,
          fillColor: inputTheme.fillColor,
          labelStyle: inputTheme.labelStyle,
          hintStyle: inputTheme.hintStyle?.copyWith(
            color: theme.colorScheme.tertiary, // هنا اللون الجديد
          ),
        ),
      ),
    );
  }
}
