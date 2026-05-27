import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateHelper {
  // ==========================================
  // 1. تنسيق التاريخ (Date Formatting)
  // ==========================================

  // تنسيق التاريخ الكامل (مثال: 11 مايو 2026)
  static String formatFullDate(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    String formatted = DateFormat('d MMMM yyyy', locale).format(date);
    return _convertToArabicNumerals(formatted);
  }

  // تنسيق اليوم والشهر فقط (مثال: 5 مارس)
  static String formatDayMonth(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    String formatted = DateFormat.MMMMd(locale).format(date);
    return _convertToArabicNumerals(formatted);
  }

  // تنسيق الشهر والسنة فقط (مثال: يناير 2024)
  static String formatYearMonth(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    String formatted = DateFormat.yMMMM(locale).format(date);
    return _convertToArabicNumerals(formatted);
  }

  // دالة مساعدة لمنع تكرار كود تحويل الأرقام الهندية لإنجليزية
  static String _convertToArabicNumerals(String input) {
    return input.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
      const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
      return arabicNumbers.indexOf(match[0]!).toString();
    });
  }

  // ==========================================
  // 2. تنسيق الوقت (Time Formatting)
  // ==========================================

  // تحويل الوقت لتنسيق 12 ساعة (AM/PM) مترجم
  static String formatTime(String timeStr, BuildContext context) {
    try {
      final locale = Localizations.localeOf(context).languageCode;
      final date = DateFormat("HH:mm").parse(timeStr);
      return DateFormat.jm(locale).format(date);
    } catch (e) {
      return timeStr;
    }
  }

  // دالة مجمعة لتنسيق التاريخ والوقت للسجلات والمواعيد (مثال: 11 مايو 2026 - 10:30 ص)
  static String formatRecordDateAndTime(dynamic data, BuildContext context) {
    if (data == null) return "";
    final rawDate = data['date']?.toString() ?? '';
    final rawTime =
        data['startTime']?.toString() ?? data['time']?.toString() ?? '';

    String displayDate = rawDate;
    if (rawDate.isNotEmpty) {
      final parsedDate = DateTime.tryParse(rawDate.split('T')[0]);
      if (parsedDate != null) {
        displayDate = formatFullDate(parsedDate, context);
      }
    }

    String displayTime = rawTime;
    if (rawTime.isNotEmpty) {
      displayTime = formatTime(rawTime, context);
    }

    if (displayDate.isEmpty && displayTime.isEmpty) return "";
    if (displayTime.isEmpty) return displayDate;
    return "$displayDate  -  $displayTime";
  }

  // ==========================================
  // 3. الوقت النسبي (Relative Time)
  // ==========================================

  // مثال: "منذ 5 دقائق"
  static String timeAgo(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return timeago.format(date, locale: locale);
  }

  // الوقت النسبي المختصر ستايل انستجرام (مثال: 5د, 1س)
  static String timeAgoShort(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      int sec = difference.inSeconds < 1 ? 1 : difference.inSeconds;
      return locale == 'ar' ? '$secث' : '${sec}s';
    } else if (difference.inMinutes < 60) {
      return locale == 'ar'
          ? '${difference.inMinutes}د'
          : '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return locale == 'ar'
          ? '${difference.inHours}س'
          : '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return locale == 'ar' ? '${difference.inDays}ي' : '${difference.inDays}d';
    } else {
      return locale == 'ar'
          ? '${difference.inDays ~/ 7}أ'
          : '${difference.inDays ~/ 7}w';
    }
  }

  // ==========================================
  // 4. وظائف إضافية (Age, Working Days & Hours)
  // ==========================================

  // حساب العمر بشكل دقيق ومترجم (أيام، شهور، سنين)
  static String calculateAge(DateTime birthDate, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    // معالجة فرق الأيام والشهور
    if (now.day < birthDate.day) months--;
    if (months < 0) {
      years--;
      months += 12;
    }

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
    } else {
      if (years > 0) {
        return years == 1 ? "1 year" : "$years years";
      } else {
        if (months <= 0) return "< 1 month";
        return months == 1 ? "1 month" : "$months months";
      }
    }
  }

  // تنسيق أيام العمل للعيادات (مثال: من الأحد إلى الخميس)
  static String formatWorkingDays(
    Map<String, dynamic> daysMap,
    BuildContext context,
  ) {
    final l10n = context.l10n;
    final List<String> weekDays = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];

    final Map<String, String> localizedDays = {
      'Saturday': l10n.saturday,
      'Sunday': l10n.sunday,
      'Monday': l10n.monday,
      'Tuesday': l10n.tuesday,
      'Wednesday': l10n.wednesday,
      'Thursday': l10n.thursday,
      'Friday': l10n.friday,
    };

    List<String> selectedKeys = [];
    List<int> selectedIndices = [];

    for (int i = 0; i < weekDays.length; i++) {
      final day = weekDays[i];
      if (daysMap[day] == true) {
        selectedKeys.add(day);
        selectedIndices.add(i);
      }
    }

    if (selectedKeys.isEmpty) return "";
    if (selectedKeys.length == 7) return l10n.daily;

    if (selectedKeys.length == 6) {
      final missingDayKey = weekDays.firstWhere((day) => daysMap[day] != true);
      return "${l10n.dailyExcept} ${localizedDays[missingDayKey]}";
    }

    bool isConsecutive =
        (selectedIndices.last - selectedIndices.first) ==
        (selectedIndices.length - 1);
    if (isConsecutive && selectedKeys.length >= 3) {
      return "${l10n.fromTime} ${localizedDays[selectedKeys.first]} ${l10n.toTime} ${localizedDays[selectedKeys.last]}";
    }

    final String separator =
        Localizations.localeOf(context).languageCode == 'ar' ? '، ' : ', ';
    return selectedKeys.map((key) => localizedDays[key]).join(separator);
  }

  static String formatWorkingHours(
    String startTime,
    String endTime,
    BuildContext context,
  ) {
    if (startTime.isEmpty || endTime.isEmpty) return "";

    bool is24HoursStart =
        startTime.startsWith("00:00") ||
        startTime.toLowerCase().contains("12:00 am");
    bool is24HoursEnd =
        endTime.startsWith("23:59") ||
        endTime.toLowerCase().contains("11:59 pm");

    if (is24HoursStart && is24HoursEnd) {
      return context.l10n.open24Hours;
    }

    final formattedStart = formatTime(startTime, context);
    final formattedEnd = formatTime(endTime, context);

    return "$formattedStart - $formattedEnd";
  }
}
