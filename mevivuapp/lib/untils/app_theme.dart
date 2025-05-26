import 'package:flutter/material.dart';

class AppTheme {
  // Secondary Colors
  static const secondary50 = Color(0xFFe9f1ff);
  static const secondary100 = Color(0xFFcef0ff);
  static const secondary200 = Color(0xFFa2e6ff);
  static const secondary300 = Color(0xFF6bd6ff);
  static const secondary400 = Color(0xFF26c2ff);
  static const secondary500 = Color(0xFF009aff);
  static const secondary600 = Color(0xFF0070ff);
  static const secondary700 = Color(0xFF0055ff);
  static const secondary800 = Color(0xFF0048e6);
  static const secondary900 = Color(0xFF0043b3);
  static const secondary950 = Color(0xFF002d73);

  // Primary Colors
  static const primary50 = Color(0xFFfffcf8);
  static const primary100 = Color(0xFFfcfbc2);
  static const primary200 = Color(0xFFfcfb87);
  static const primary300 = Color(0xFFfffc43);
  static const primary400 = Color(0xFFffee0a);
  static const primary500 = Color(0xFFefed03);
  static const primary600 = Color(0xFFCEA700);
  static const primary700 = Color(0xFFa47804);
  static const primary800 = Color(0xFF885d0b);
  static const primary900 = Color(0xFF734c10);
  static const primary950 = Color(0xFF432805);

  // Neutral Colors
  static const neutral50 = Color(0xFFf8f8f8);
  static const neutral100 = Color(0xFFf1f1ef);
  static const neutral200 = Color(0xFFe5e3e3);
  static const neutral300 = Color(0xFFd3cece);
  static const neutral400 = Color(0xFFb8b1b1);
  static const neutral500 = Color(0xFF9e9595);
  static const neutral600 = Color(0xFF898080);
  static const neutral700 = Color(0xFF6e6767);
  static const neutral800 = Color(0xFF5d5757);
  static const neutral900 = Color(0xFF504c4c);
  static const neutral950 = Color(0xFF292626);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primary500,
      scaffoldBackgroundColor: neutral100,
      appBarTheme: AppBarTheme(
        backgroundColor: primary500,
        foregroundColor: neutral950,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary400,
        foregroundColor: neutral950,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: neutral900),
        bodyMedium: TextStyle(color: neutral700),
        titleLarge: TextStyle(color: neutral950, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary400,
          foregroundColor: neutral950,
        ),
      ),
      cardTheme: CardTheme(
        color: neutral50,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}