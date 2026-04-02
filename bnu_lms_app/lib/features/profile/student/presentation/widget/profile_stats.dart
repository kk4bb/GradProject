import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';


class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: StatCard(label: 'GPA', value: '3.85')),
        SizedBox(width: 12.w),
        Expanded(child: StatCard(label: 'Credits', value: '92')),
        SizedBox(width: 12.w),
        Expanded(child: StatCard(label: 'Rank', value: '7th')),
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
      padding: REdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
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
          SizedBox(height: 4.h),
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