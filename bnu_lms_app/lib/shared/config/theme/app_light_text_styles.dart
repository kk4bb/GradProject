import 'package:flutter/material.dart';
import '../../resources/colors_manager.dart';
import 'app_typography.dart';

class AppLightTextStyles {

  // Display
  static TextStyle get displayLarge  =>
      AppTypography.displayLarge.copyWith(color: ColorsManager.black);

  static TextStyle get displayMedium =>
      AppTypography.displayMedium.copyWith(color: ColorsManager.black);

  // Headline
  static TextStyle get headlineLarge =>
      AppTypography.headlineLarge.copyWith(color: ColorsManager.black);

  static TextStyle get headlineMedium =>
      AppTypography.headlineMedium.copyWith(color: ColorsManager.black);

  static TextStyle get headlineSmall  =>
      AppTypography.headlineSmall.copyWith(color: ColorsManager.black);

  // Title
  static TextStyle get titleLarge  =>
      AppTypography.titleLarge.copyWith(color: ColorsManager.black);

  static TextStyle get titleMedium =>
      AppTypography.titleMedium.copyWith(color: ColorsManager.grayDark);

  // Body
  static TextStyle get bodyLarge =>
      AppTypography.bodyLarge.copyWith(color: ColorsManager.grayDark);

  static TextStyle get bodyMedium =>
      AppTypography.bodyMedium.copyWith(color: ColorsManager.grayDark);

  static TextStyle get bodySmall =>
      AppTypography.bodySmall.copyWith(color: ColorsManager.grayMedium);

  // Label
  static TextStyle get labelLarge =>
      AppTypography.labelLarge.copyWith(color: ColorsManager.grayDark);

  static TextStyle get labelMedium =>
      AppTypography.labelMedium.copyWith(color: ColorsManager.grayMedium);

  static TextStyle get labelSmall =>
      AppTypography.labelSmall.copyWith(color: ColorsManager.grayDark);
}
