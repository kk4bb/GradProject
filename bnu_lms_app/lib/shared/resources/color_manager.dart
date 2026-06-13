import 'package:flutter/material.dart';
import 'colors_manager.dart';

class ColorManager {
  static const Color primary = ColorsManager.blue;
  static const Color background = ColorsManager.lightBackground;
  static const Color cardBackground = ColorsManager.white;
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color textPrimary = ColorsManager.black;
  static const Color textSecondary = ColorsManager.grayDark;
  static const Color error = ColorsManager.red;
  static const Color success = ColorsManager.green;
  static const Color warning = ColorsManager.yellow;
  
  // For Dark Mode support (can be handled via ThemeProvider, but keeping these for templates)
  static const Color darkBackground = ColorsManager.darkBackground;
  static const Color darkCardBackground = ColorsManager.darkSurface;
}
