import 'package:flutter/material.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  const EmailField({
    super.key,
    required this.controller,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.readOnly = false,
  });

  static bool isValid(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: AppLocalizations.of(context)!.email,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: "assets/icons/email.svg",
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted,

      readOnly: readOnly,

      fillColor: readOnly ? Colors.grey.shade200 : null,

      suffixIcon: readOnly
          ? const Icon(Icons.lock_outline, color: Colors.grey, size: 20)
          : null,

      validator: (val) => ValidationHelper.validateEmail(val, context),
    );
  }
}
