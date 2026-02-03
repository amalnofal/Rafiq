import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago; // ✅ 1. استدعاء المكتبة

class DateHelper {
  /// ترجمة اسم الشهر + سنة مثل "May 2025" أو "مايو 2025"
  static String formatYearMonth(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    String formatted = DateFormat.yMMMd(locale).format(date);

    // نحول أي أرقام عربية إلى أرقام إنجليزية
    formatted = formatted.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
      const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
      return arabicNumbers.indexOf(match[0]!).toString();
    });

    return formatted;
  }

  /// حساب الوقت النسبي "منذ X دقيقة/ساعات/أيام/شهور/سنين"
  static String timeAgo(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return timeago.format(date, locale: locale);
  }
}