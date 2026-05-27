import 'package:flutter/services.dart';

class ArabicToEnglishNumbersFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    String newText = newValue.text;
    for (int i = 0; i < arabicNumbers.length; i++) {
      newText = newText.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }

    return newValue.copyWith(text: newText, selection: newValue.selection);
  }

  static TextDirection getTextDirection(String text) {
    final trimmedText = text.trim();

    if (trimmedText.isEmpty) return TextDirection.ltr;
    // فحص لو أول حرف ينتمي للحروف العربية
    final int firstCharCode = text.trim().codeUnitAt(0);
    if (firstCharCode >= 0x0600 && firstCharCode <= 0x06FF) {
      return TextDirection.rtl; // لغة عربية -> من اليمين لليسار
    }
    return TextDirection.ltr; // لغة إنجليزية أو رموز -> من اليسار لليمين
  }
}
