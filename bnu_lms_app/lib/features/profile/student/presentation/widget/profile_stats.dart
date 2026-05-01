import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';


class ProfileStatsGrid extends StatelessWidget {
  final int creditHours;
  final int coursesCount;

  const ProfileStatsGrid({
    super.key,
    required this.creditHours,
    required this.coursesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: StatCard(label: 'Courses', value: '$coursesCount')),
        SizedBox(width: 12.0),
        Expanded(child: StatCard(label: 'Credits', value: '$creditHours')),
        SizedBox(width: 12.0),
        Expanded(child: const StatCard(label: 'GPA', value: '3.85')),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: isLight
                ? AppLightTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.blue,
            )
                : AppDarkTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.blue,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            label,
            style: isLight
                ? AppLightTextStyles.bodySmall.copyWith(
              color: ColorsManager.grayMedium,
            )
                : AppDarkTextStyles.bodySmall.copyWith(
              color: ColorsManager.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}