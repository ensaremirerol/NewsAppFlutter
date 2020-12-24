import 'package:flutter/material.dart';

import './shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xcaced3),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  static ThemeData themeData;
  static ThemeManager instance;

  static void initThemeManager() {
    instance = ThemeManager();
  }

  ThemeManager() {
    SharedPreferencesManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        themeData = lightTheme;
      } else {
        themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  ThemeData getTheme() {
    return themeData ?? lightTheme;
  }

  void switchTheme() async {
    if (themeData == lightTheme) {
      themeData = darkTheme;
      SharedPreferencesManager.saveData("themeMode", "dark");
    } else {
      themeData = lightTheme;
      SharedPreferencesManager.saveData("themeMode", "light");
    }
    notifyListeners();
  }
}
