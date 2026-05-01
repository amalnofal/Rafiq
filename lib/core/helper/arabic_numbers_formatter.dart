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

    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}