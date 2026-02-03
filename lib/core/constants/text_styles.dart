import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // ========================================================================
  // 1. CONFIGURATION
  // ========================================================================
  static const String appfont = 'Tajawal';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  // static const FontWeight semiBold = FontWeight.w600;
  // static const FontWeight bold = FontWeight.w700;

  // ========================================================================
  // 2. TEXT STYLES (Responsive .sp)
  // ========================================================================

  // ========== DISPLAY ==========
  static TextStyle displayLarge({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 32.sp,
      fontWeight: regular,
      color: color,
    );
  }

  static TextStyle displayMedium({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 28.sp,
      fontWeight: regular,
      color: color,
    );
  }

  // ========== HEADLINES ==========
  static TextStyle headlineLarge({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 20.sp,
      fontWeight: medium,
      color: color,
    );
  }

  static TextStyle headlineMedium({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 18.sp,
      fontWeight: medium,
      color: color,
    );
  }

  static TextStyle headlineSmall({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 16.sp,
      fontWeight: medium,
      color: color,
    );
  }

  // ========== BODY ==========
  static TextStyle bodyLarge({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 16.sp,
      fontWeight: regular,
      color: color,
    );
  }

  static TextStyle bodyMedium({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 14.sp,
      fontWeight: regular,
      color: color,
    );
  }

  static TextStyle bodySmall({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 12.sp,
      fontWeight: regular,
      color: color,
    );
  }

  // ========== LABEL ==========
  static TextStyle labelLarge({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 16.sp,
      fontWeight: regular,
      color: color,
    );
  }

  static TextStyle labelMedium({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 14.sp,
      fontWeight: regular,
      color: color,
    );
  }

  static TextStyle labelSmall({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 12.sp,
      fontWeight: regular,
      color: color,
    );
  }

  // ========== Title ==========

  static TextStyle titleLarge({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 16.sp,
      fontWeight: medium,
      color: color,
    );
  }

  static TextStyle titleMedium({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 14.sp,
      fontWeight: medium,
      color: color,
    );
  }

  static TextStyle titleSmall({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 12.sp,
      fontWeight: medium,
      color: color,
    );
  }

  // ========== BUTTON ==========
  static TextStyle buttonLarge({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 16.sp,
      fontWeight: regular,
      color: color,
    );
  }

  static TextStyle button({Color? color}) {
    return TextStyle(
      fontFamily: appfont,
      fontSize: 14.sp,
      fontWeight: regular,
      color: color,
    );
  }
}
