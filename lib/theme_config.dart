import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    // Other light theme configurations
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF6C63FF),
    brightness: Brightness.dark,
  );

  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFE5E5E5);
  static const Color accentColor = Color(0xFF6C63FF);
  static const Color backgroundColor = Color(0xFFE5E5E5);
  static const Color textColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFF6C63FF);
  static const Color dividerColor = Color(0xFFE5E5E5);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);
}
