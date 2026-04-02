import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class LearningOutcomesSection extends StatelessWidget {
  const LearningOutcomesSection({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Outcomes',
            style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
          ),
          SizedBox(height: 16.h),
          _buildOutcomeRow(context, 'Master dynamic programming concepts', true),
          _buildOutcomeRow(context, 'Analyze time & space complexity', true),
          _buildOutcomeRow(context, 'Apply Graph Theory to solve problems', true),
          _buildOutcomeRow(context, 'Advanced sorting techniques (Upcoming)', false),
        ],
      ),
    );
  }

  Widget _buildOutcomeRow(BuildContext context, String text, bool isCompleted) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.remove_circle_outline,
            color: isCompleted ? ColorsManager.green : ColorsManager.grayMedium, // Replaced hardcoded green
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: isLight
                  ? AppLightTextStyles.labelMedium.copyWith(
                color: isCompleted ? ColorsManager.black : ColorsManager.grayMedium,
              )
                  : AppDarkTextStyles.labelMedium.copyWith(
                color: isCompleted ? ColorsManager.white : ColorsManager.grayMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}