import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_app_provider/config/config.dart';

class ThemeProvider with ChangeNotifier {
  AppTheme _appTheme;
  // final SharedPreferences _preferences;

  ThemeProvider(
    this._appTheme,
    // this._preferences
  );

  AppTheme get appTheme => _appTheme;

  Future<void> setTheme(AppTheme newTheme) async {
    _appTheme = newTheme;
    notifyListeners();

    // await _preferences.setInt('selectedColor', newTheme.selectedColor);
    // await _preferences.setBool('isDarkMode', newTheme.isDarkMode);
  }

  void toggleDarkMode(bool value) {
    final darkModeActive = _appTheme.copyWith(isDarkMode: value);
    setTheme(darkModeActive);
  }

  void changeColor(int index) {
    final newColor = _appTheme.copyWith(selectedColor: index);
    setTheme(newColor);
  }

  // Método para cargar la configuración de preferencias compartidas
  // static Future<ThemeProvider> loadFromPreferences() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   final selectedColor = preferences.getInt('selectedColor') ?? 0;
  //   final isDarkMode = preferences.getBool('isDarkMode') ?? false;

  //   final appTheme =
  //       AppTheme(selectedColor: selectedColor, isDarkMode: isDarkMode);

  //   return ThemeProvider(appTheme, preferences);
  // }
}
