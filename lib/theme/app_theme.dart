import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 33, 100, 243),
        brightness: Brightness.light,
      ),
      cardTheme: const CardTheme(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 155, 0, 255),
        brightness: Brightness.dark,
      ),
      cardTheme: const CardTheme(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}