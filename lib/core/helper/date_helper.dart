import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  /// ترجمة اسم الشهر + سنة مثل "May 2025" أو "مايو 2025"
  /// وتحويل أي أرقام عربية إلى إنجليزية
  static String formatYearMonth(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    String formatted = DateFormat.yMMMM(locale).format(date);

    // نحول أي أرقام عربية إلى أرقام إنجليزية
    formatted = formatted.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
      const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
      return arabicNumbers.indexOf(match[0]!).toString();
    });

    return formatted;
  }

  /// حساب الوقت النسبي "منذ X دقيقة/ساعات/أيام/شهور/سنين"
  static String timeAgo(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final locale = Localizations.localeOf(context).languageCode;

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return locale == 'ar'
          ? 'منذ $years ${years == 1 ? 'سنة' : 'سنوات'}'
          : '$years ${years == 1 ? 'year ago' : 'years ago'}';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return locale == 'ar'
          ? 'منذ $months ${months == 1 ? 'شهر' : 'شهور'}'
          : '$months ${months == 1 ? 'month ago' : 'months ago'}';
    } else if (difference.inDays >= 1) {
      final days = difference.inDays;
      return locale == 'ar'
          ? 'منذ $days ${days == 1 ? 'يوم' : 'أيام'}'
          : '$days ${days == 1 ? 'day ago' : 'days ago'}';
    } else if (difference.inHours >= 1) {
      final hours = difference.inHours;
      return locale == 'ar'
          ? 'منذ $hours ${hours == 1 ? 'ساعة' : 'ساعات'}'
          : '$hours ${hours == 1 ? 'hour ago' : 'hours ago'}';
    } else if (difference.inMinutes >= 1) {
      final minutes = difference.inMinutes;
      return locale == 'ar'
          ? 'منذ $minutes ${minutes == 1 ? 'دقيقة' : 'دقائق'}'
          : '$minutes ${minutes == 1 ? 'minute ago' : 'minutes ago'}';
    } else {
      return locale == 'ar' ? 'الآن' : 'just now';
    }
  }
}
