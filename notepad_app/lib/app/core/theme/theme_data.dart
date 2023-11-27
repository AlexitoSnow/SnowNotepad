import 'package:flutter/material.dart';

class FormattedTheme {
  static final light = ThemeData(
    primarySwatch: Colors.deepPurple,
    primaryColor: Colors.deepPurpleAccent,
    hintColor: const Color.fromARGB(255, 47, 0, 175),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(overflow: TextOverflow.ellipsis),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.deepPurpleAccent,
      secondary: Colors.deepPurpleAccent,
    ),
    primaryColorLight: Colors.deepPurpleAccent,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent,
      ),
    ),
    primaryTextTheme: Typography.blackRedmond,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
    ),
  );

  static final dark = ThemeData(
    primarySwatch: Colors.deepPurple,
    primaryColor: Colors.deepPurpleAccent,
    hintColor: Colors.deepPurpleAccent,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(overflow: TextOverflow.ellipsis),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.deepPurpleAccent,
      secondary: Colors.deepPurpleAccent,
    ),
    primaryColorDark: Colors.deepPurpleAccent,
    primaryTextTheme: Typography.whiteRedmond,
    scaffoldBackgroundColor: Colors.grey[900],
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
    ),
  );
}
