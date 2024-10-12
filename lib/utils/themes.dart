import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    backgroundColor: Colors.grey[300]!.withOpacity(0.97),
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFE0E0E0), // grey 300
    primary: Colors.white,
    secondary: Color(0xFF757575), //grey 600
    tertiary: Color(0xFFBDBDBD), //grey 400
    primaryContainer: Color.fromARGB(255, 244, 244, 244),
    surfaceBright: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    backgroundColor: const Color(0xFF292929).withOpacity(0.97),
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF292929),
    primary: Color.fromRGBO(30, 30, 30, 1),
    secondary: Color(0xFFB8B8B8),
    tertiary: Color(0xFF757575),
    primaryContainer: Color(0xFF3D3D3D),
    surfaceBright: Colors.white,
  ),
);
