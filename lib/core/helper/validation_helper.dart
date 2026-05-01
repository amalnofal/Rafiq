import 'package:flutter/material.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ValidationHelper {
  // Regex للإيميل
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  // Regex لرقم الهاتف (دولي أو محلي)
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');

  // 1. حقل إجباري عام
  static String? validateRequired(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    return null;
  }

  // 2. الاسم (إجباري + لا يقل عن 2 ولا يزيد عن 50)
  static String? validateName(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val.trim().length < 2) {
      return AppLocalizations.of(context)!.nameTooShort;
    }
    if (val.trim().length > 50) {
      return AppLocalizations.of(context)!.nameTooLong;
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

  // 4. رقم الهاتف (اختياري/إجباري)
  static String? validatePhone(
    String? val,
    BuildContext context, {
    bool isOptional = false,
  }) {
    // لو اختياري وفاضي -> تمام
    if (isOptional && (val == null || val.trim().isEmpty)) {
      return null;
    }

    // لو إجباري وفاضي -> خطأ
    if (!isOptional && (val == null || val.trim().isEmpty)) {
      return AppLocalizations.of(context)!.fieldRequired;
    }

    // التحقق من الصيغة
    if (!_phoneRegex.hasMatch(val!.trim())) {
      return AppLocalizations.of(context)!.invalidPhoneNumber;
    }

    return null;
  }

  // 5. كلمة المرور (تطبيق شروط الباك إند الصارمة)
  static String? validateStrongPassword(String? val, BuildContext context) {
    if (val == null || val.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    // الطول (8 - 100)
    if (val.length < 8) {
      return AppLocalizations.of(context)!.passwordRuleLength;
    }
    if (val.length > 100) {
      return AppLocalizations.of(context)!.passwordTooLong;
    }
    // حرف كبير
    if (!val.contains(RegExp(r'[A-Z]'))) {
      return AppLocalizations.of(context)!.passwordRuleUpperCase;
    }
    // حرف صغير
    if (!val.contains(RegExp(r'[a-z]'))) {
      return AppLocalizations.of(context)!.passwordRuleLowerCase;
    }
    // رقم
    if (!val.contains(RegExp(r'[0-9]'))) {
      return AppLocalizations.of(context)!.passwordRuleNumber;
    }
    if (!val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppLocalizations.of(context)!.passwordRuleSymbol;
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

  static String? validateAge(DateTime? dateOfBirth, BuildContext context) {
    if (dateOfBirth == null) {
      return AppLocalizations.of(context)!.fieldRequired;
    }

    final DateTime today = DateTime.now();

    // حساب الفرق في السنين
    int age = today.year - dateOfBirth.year;

    // تدقيق الحساب: لو لسه مجاش عيد ميلاده في السنة دي، نقص سنة من العمر
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }

    if (age < 18) {
      return AppLocalizations.of(context)!.ageTooYoung;
    }

    return null;
  }

  // 3. العنوان (لا يقل عن 4 حروف)
  static String? validateAddress(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val.trim().length < 4) {
      return AppLocalizations.of(context)!.addressTooShort;
    }
    return null;
  }

  // 4. ساعات العمل (لا تقل عن 3 حروف، مثلاً: 9-5)
  static String? validateWorkingHours(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val.trim().length < 3) {
      return AppLocalizations.of(context)!.hoursTooShort;
    }
    return null;
  }

  // 5. الوصف (لا يقل عن 10 حروف عشان يكون وصف حقيقي)
  static String? validateDescription(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return null;
    }

    if (val.trim().length < 10) {
      return AppLocalizations.of(context)!.descTooShort;
    }

    return null;
  }

  // 6. التخصص (لا يقل عن 3 حروف)
  static String? validateSpecialization(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val.trim().length < 3) {
      return AppLocalizations.of(context)!.specializationTooShort;
    }
    return null;
  }

  // 7. نصوص قصيرة (مثل السلالة أو اللون - لا تقل عن 3 حروف)
  static String? validatePetAttribute(String? val, BuildContext context) {
    if (val == null || val.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    if (val.trim().length < 3) {
      return AppLocalizations.of(context)!.textTooShort3;
    }
    return null;
  }
}
