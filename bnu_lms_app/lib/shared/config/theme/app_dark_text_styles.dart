import 'package:flutter/material.dart';
import '../../resources/colors_manager.dart';
import 'app_typography.dart';

class AppDarkTextStyles {

  // Display
  static TextStyle get displayLarge =>
      AppTypography.displayLarge.copyWith(color: ColorsManager.darkTextPrimary);

  static TextStyle get displayMedium =>
      AppTypography.displayMedium.copyWith(color: ColorsManager.darkTextPrimary);

  // Headline
  static TextStyle get headlineLarge =>
      AppTypography.headlineLarge.copyWith(color: ColorsManager.darkTextPrimary);

  static TextStyle get headlineMedium =>
      AppTypography.headlineMedium.copyWith(color: ColorsManager.darkTextPrimary);

  static TextStyle get headlineSmall =>
      AppTypography.headlineSmall.copyWith(color: ColorsManager.white);

  // Title
  static TextStyle get titleLarge =>
      AppTypography.titleLarge.copyWith(color: ColorsManager.darkTextPrimary);

  static TextStyle get titleMedium =>
      AppTypography.titleMedium.copyWith(color: ColorsManager.darkTextSecondary);

  // Body
  static TextStyle get bodyLarge =>
      AppTypography.bodyLarge.copyWith(color: ColorsManager.darkTextPrimary);

  static TextStyle get bodyMedium =>
      AppTypography.bodyMedium.copyWith(color: ColorsManager.darkTextSecondary);

  static TextStyle get bodySmall =>
      AppTypography.bodySmall.copyWith(color: ColorsManager.darkTextSecondary);

  // Label
  static TextStyle get labelLarge =>
      AppTypography.labelLarge.copyWith(color: ColorsManager.darkTextSecondary);

  static TextStyle get labelMedium =>
      AppTypography.labelMedium.copyWith(color: ColorsManager.darkTextSecondary);

  static TextStyle get labelSmall =>
      AppTypography.labelSmall.copyWith(color: ColorsManager.darkTextSecondary);
}
