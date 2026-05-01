import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateHelper {
  // 1. دالة لتنسيق التاريخ (مثال: يناير 2024) مع تحويل الأرقام لإنجليزية
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

  // دالة لتنسيق التاريخ الكامل (يوم - شهر - سنة)
  static String formatFullDate(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    // yMMMMd بتجيب اليوم والشهر والسنة حسب لغة الموبايل
    String formatted = DateFormat.yMMMMd(locale).format(date);

    // نحول أي أرقام عربية إلى أرقام إنجليزية زي ما عملتي فوق
    formatted = formatted.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
      const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
      return arabicNumbers.indexOf(match[0]!).toString();
    });

    return formatted;
  }

  // 4. دالة لتنسيق اليوم والشهر فقط (مثال: 5 مارس / March 5)
  static String formatDayMonth(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    // MMMMd بتجيب اليوم والشهر حسب لغة الموبايل
    String formatted = DateFormat.MMMMd(locale).format(date);

    // نحول أي أرقام عربية إلى أرقام إنجليزية
    formatted = formatted.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
      const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
      return arabicNumbers.indexOf(match[0]!).toString();
    });

    return formatted;
  }

  // 2. دالة حساب الوقت النسبي "منذ X دقيقة/ساعات/أيام/شهور/سنين"
  static String timeAgo(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return timeago.format(date, locale: locale);
  }

  // دالة حساب الوقت النسبي المختصر (ستايل انستجرام)
  static String timeAgoShort(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      int sec = difference.inSeconds < 1 ? 1 : difference.inSeconds;
      return locale == 'ar' ? '$secث' : '${sec}s';
    } else if (difference.inMinutes < 60) {
      return locale == 'ar' ? '${difference.inMinutes}د' : '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return locale == 'ar' ? '${difference.inHours}س' : '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return locale == 'ar' ? '${difference.inDays}ي' : '${difference.inDays}d';
    } else {
      return locale == 'ar' ? '${difference.inDays ~/ 7}أ' : '${difference.inDays ~/ 7}w';
    }
  }

  // دالة لتحويل الوقت من تنسيق 24 ساعة إلى 12 ساعة (AM/PM) مترجم
  static String formatTime(String timeStr, BuildContext context) {
    try {
      final locale = Localizations.localeOf(context).languageCode;
      // بنفترض إن الوقت جاي من السيرفر كدة "15:30" أو "15:30:00"
      final date = DateFormat("HH:mm").parse(timeStr);

      return DateFormat.jm(locale).format(date);
    } catch (e) {
      return timeStr; 
    }
  }

  // 3. الدالة الجديدة لحساب العمر بشكل دقيق ومترجم (أيام، شهور، سنين)
  static String calculateAge(DateTime birthDate, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    // لو لسه مجاش يوم ميلاده في الشهر الحالي، ننقص شهر
    if (now.day < birthDate.day) {
      months--;
    }

    // لو الشهور بالسالب، ننقص سنة ونزود 12 شهر
    if (months < 0) {
      years--;
      months += 12;
    }

    // تنسيق النص بناءً على لغة التطبيق (العربية)
    if (locale == 'ar') {
      if (years > 0) {
        if (years == 1) return "سنة واحدة";
        if (years == 2) return "سنتان";
        if (years >= 3 && years <= 10) return "$years سنوات";
        return "$years سنة";
      } else {
        if (months <= 0) return "أقل من شهر";
        if (months == 1) return "شهر واحد";
        if (months == 2) return "شهران";
        if (months >= 3 && months <= 10) return "$months شهور";
        return "$months شهراً";
      }
    }
    // تنسيق النص بناءً على لغة التطبيق (الإنجليزية)
    else {
      if (years > 0) {
        return years == 1 ? "1 year" : "$years years";
      } else {
        if (months <= 0) return "< 1 month";
        return months == 1 ? "1 month" : "$months months";
      }
    }
  }
}
