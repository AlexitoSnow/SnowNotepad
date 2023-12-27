import 'package:flutter/material.dart';

const primaryColor = Colors.deepPurpleAccent;
const secondaryColor = Colors.deepPurple;

class FormattedTheme {
  static final light = ThemeData(
    primarySwatch: secondaryColor,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    hintColor: const Color.fromARGB(255, 47, 0, 175),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 20,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
    ),
    primaryColorLight: primaryColor,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    primaryTextTheme: Typography.blackRedmond,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
    ),
  );

  static final dark = ThemeData(
    primarySwatch: secondaryColor,
    primaryColor: primaryColor,
    hintColor: secondaryColor,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 20,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
    ),
    primaryColorDark: primaryColor,
    primaryTextTheme: Typography.whiteRedmond,
    scaffoldBackgroundColor: Colors.grey[900],
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(124, 77, 255, 0.7),
    ),
  );
}
