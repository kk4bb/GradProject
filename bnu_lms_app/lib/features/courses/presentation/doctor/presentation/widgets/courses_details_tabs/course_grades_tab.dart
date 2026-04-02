import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';


class CourseGradesTab extends StatelessWidget {
  const CourseGradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gradebook',
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
              ),
              Icon(Icons.file_download_outlined, color: ColorsManager.blue, size: 24.sp),
            ],
          ),
          SizedBox(height: 20.h),

          _buildGradeItem(context, 'Midterm Project', 'Oct 24, 2023', 'Graded', 28, 30),
          _buildGradeItem(context, 'Weekly Quiz 4', 'Oct 18, 2023', 'Graded', 30, 30),
          _buildGradeItem(context, 'Weekly Quiz 3', 'Oct 11, 2023', 'Graded', 25, 30),
          _buildGradeItem(context, 'Assignment 2', 'Oct 05, 2023', 'Graded', 18, 20),
        ],
      ),
    );
  }

  Widget _buildGradeItem(BuildContext context, String title, String date, String status, int score, int total) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8.r, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
              SizedBox(height: 4.h),
              Text(date, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('$score', style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(color: ColorsManager.blue)),
                  Text('/$total', style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
                ],
              ),
              SizedBox(height: 4.h),
              Text(status, style: AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}