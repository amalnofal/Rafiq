import 'package:flutter/material.dart';
import 'package:rafiq/core/theme/dark_theme.dart';
import 'package:rafiq/core/theme/light_theme.dart';

class AppTheme {
  // Get Light Theme
  static ThemeData light(BuildContext context) {
    return LightTheme.getTheme(context);
  }

  // Get Dark Theme
  static ThemeData dark(BuildContext context) {
    return DarkTheme.getTheme(context);
  }
}
