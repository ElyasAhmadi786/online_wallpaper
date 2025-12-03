// TODO 69: Import necessary packages
import 'package:flutter/material.dart';

// TODO 70: Define application themes
class AppThemes {
  // TODO 71: Dark theme (main theme)
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // TODO 72: Light theme (optional)
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );

  // TODO 73: Category colors mapping
  static Map<String, Color> categoryColors = {
    'blue': Colors.blue,
    'green': Colors.green,
    'purple': Colors.purple,
    'orange': Colors.orange,
    'brown': Colors.brown,
    'indigo': Colors.indigo,
    'red': Colors.red,
    'teal': Colors.teal,
  };

  // TODO 74: Get color by category name
  static Color getCategoryColor(String colorName) {
    return categoryColors[colorName] ?? Colors.grey;
  }
}