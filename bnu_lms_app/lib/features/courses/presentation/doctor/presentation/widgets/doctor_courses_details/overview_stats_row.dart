import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class OverviewStatsRow extends StatelessWidget {
  const OverviewStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.assignment,
            iconColor: ColorsManager.blue,
            iconBgColor: const Color(0xFFEEF3FF),
            value: '12',
            label: 'Total Assignments',
            isLight: isLight,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: StatCard(
            icon: Icons.people,
            iconColor: ColorsManager.green, // Replaced hardcoded green
            iconBgColor: const Color(0xFFE6F4EA),
            value: '92%',
            label: 'Avg. Attendance',
            isLight: isLight,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String value;
  final String label;
  final bool isLight;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.label,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10.r, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
          ),
          Text(
            label,
            style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}