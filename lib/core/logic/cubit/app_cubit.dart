import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  Locale? locale;
  bool isDark = false;

  Future<void> initApp() async {
    final prefs = await SharedPreferences.getInstance();

    final langCode = prefs.getString('lang');
    final darkMode = prefs.getBool('darkMode') ?? false;

    if (langCode != null) locale = Locale(langCode);
    isDark = darkMode;

    emit(AppSettingsChanged());
  }

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    if (locale?.languageCode == 'en') {
      locale = const Locale('ar');
    } else {
      locale = const Locale('en');
    }

    await prefs.setString('lang', locale!.languageCode);
    emit(AppSettingsChanged());
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = !isDark;
    await prefs.setBool('darkMode', isDark);
    emit(AppSettingsChanged());
  }
}
