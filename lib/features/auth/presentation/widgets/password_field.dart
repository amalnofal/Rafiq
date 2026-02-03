import 'package:flutter/material.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    this.labelText,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: labelText ?? AppLocalizations.of(context)!.password,

      keyboardType: TextInputType.visiblePassword,
      prefixIcon: "assets/icons/security.svg",
      isPassword: true,

      controller: controller,
      textInputAction: textInputAction,
      onSubmitted: onFieldSubmitted,
      onChanged: onChanged,

      validator:
          validator ?? (val) => ValidationHelper.validateRequired(val, context),
    );
  }
}
