import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class AppController extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isDarkMode = false;

  Locale get locale => _locale;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final savedLang = prefs.getString('language');
    final savedTheme = prefs.getBool('darkMode');

    final systemLang = ui.PlatformDispatcher.instance.locale.languageCode;

    _locale = Locale(savedLang ?? systemLang);
    _isDarkMode = savedTheme ?? false;

    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    _locale = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');

    await prefs.setString('language', _locale.languageCode);

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = !_isDarkMode;
    await prefs.setBool('darkMode', _isDarkMode);

    notifyListeners();
  }
}
