import 'package:flutter/material.dart';

final colorList = <Color>[
  Colors.blueAccent,
  Colors.teal,
  Colors.greenAccent,
  Colors.red.shade900,
  Colors.purple.shade700,
  Colors.deepPurple.shade900,
  Colors.orangeAccent,
  Colors.pinkAccent,
];

class AppTheme {
  //* Variables para manejar los colores del tema
  final int selectedColor;
  final bool isDarkMode;

  static const poppinsRegular = 'Poppins-Regular';
  static const poppinsMedium = 'Poppins-Medium';
  static const poppinsSemiBold = 'Poppins-SemiBold';

  AppTheme({
    this.selectedColor = 0,
    this.isDarkMode = false,
  })  : assert(selectedColor >= 0, 'Selected color must be greater then 0'),
        assert(selectedColor < colorList.length,
            'Selected color must be less or equal than ${colorList.length - 1}');

  ThemeData getTheme(context) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorList[selectedColor],
    );
  }

  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkMode,
  }) =>
      AppTheme(
        selectedColor: selectedColor ?? this.selectedColor,
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}
