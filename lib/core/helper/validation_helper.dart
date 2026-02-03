import 'package:flutter/material.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ValidationHelper {
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  static final RegExp _phoneRegex = RegExp(r'^01[0125][0-9]{8}$');

  // --- دوال التحقق (Validators) ---

  // 1. حقل إجباري عام
  static String? validateRequired(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    return null;
  }

  // 2. الاسم (إجباري + لا يقل عن حرفين)
  static String? validateName(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val.trim().length < 2) {
      return AppLocalizations.of(context)!.nameTooShort;
    }
    return null;
  }

  // 3. البريد الإلكتروني
  static String? validateEmail(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (!_emailRegex.hasMatch(val.trim())) {
      return AppLocalizations.of(context)!.invalidEmailAddress;
    }
    return null;
  }

  // 4. رقم الهاتف (اختياري)
  static String? validatePhone(
    String? val,
    BuildContext context, {
    bool isOptional = false,
  }) {
    // لو هو اختياري والحقل فاضي، عديها (Valid)
    if (isOptional && (val == null || val.trim().isEmpty)) {
      return null;
    }

    // لو هو إجباري وفاضي، رجع إيرور
    if (!isOptional && (val == null || val.trim().isEmpty)) {
      return AppLocalizations.of(context)!.fieldRequired;
    }

    // لازم تكون أرقام صحيحة
    if (!_phoneRegex.hasMatch(val!.trim())) {
      return AppLocalizations.of(context)!.phoneRuleLength;
    }

    return null;
  }

  // 5. كلمة المرور
  static String? validateStrongPassword(String? val, BuildContext context) {
    if (val == null || val.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val.length < 8) {
      return AppLocalizations.of(context)!.passwordRuleLength;
    }
    if (!val.contains(RegExp(r'[A-Z]'))) {
      return AppLocalizations.of(context)!.passwordRuleUpperCase;
    }
    if (!val.contains(RegExp(r'[a-z]'))) {
      return AppLocalizations.of(context)!.passwordRuleLowerCase;
    }
    if (!val.contains(RegExp(r'[0-9]'))) {
      return AppLocalizations.of(context)!.passwordRuleNumber;
    }
    return null;
  }

  // 6. تطابق كلمة المرور
  static String? validateMatch(
    String? val,
    String originalPass,
    BuildContext context,
  ) {
    if (val == null || val.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val != originalPass) {
      return AppLocalizations.of(context)!.passwordsDoNotMatch;
    }
    return null;
  }
}
