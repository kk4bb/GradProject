import 'package:flutter/material.dart';
import '../config/theme/app_typography.dart';
import 'color_manager.dart';

class AppTextStyles {
  static final TextStyle titleLarge = AppTypography.titleLarge.copyWith(
    color: ColorManager.textPrimary,
  );

  static final TextStyle titleMedium = AppTypography.titleMedium.copyWith(
    color: ColorManager.textPrimary,
  );

  static final TextStyle bodyLarge = AppTypography.bodyLarge.copyWith(
    color: ColorManager.textPrimary,
  );

  static final TextStyle bodyMedium = AppTypography.bodyMedium.copyWith(
    color: ColorManager.textPrimary,
  );

  static final TextStyle bodySmall = AppTypography.bodySmall.copyWith(
    color: ColorManager.textSecondary,
  );

  static final TextStyle labelLarge = AppTypography.labelLarge.copyWith(
    color: ColorManager.textPrimary,
  );

  static final TextStyle labelMedium = AppTypography.labelMedium.copyWith(
    color: ColorManager.textPrimary,
  );

  static final TextStyle labelSmall = AppTypography.labelSmall.copyWith(
    color: ColorManager.textSecondary,
  );

  static final TextStyle buttonText = AppTypography.labelLarge.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}
