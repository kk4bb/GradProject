import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart'; // Make sure this import path is correct

class DoctorCourseCard extends StatelessWidget {
  final String academicYear;
  final String courseName;
  final String studentsCount;
  final String timeString;
  final IconData courseIcon;
  final VoidCallback onManageTap;

  const DoctorCourseCard({
    super.key,
    required this.academicYear,
    required this.courseName,
    required this.studentsCount,
    required this.timeString,
    required this.courseIcon,
    required this.onManageTap,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: isLight
            ? [
          BoxShadow(
            color: ColorsManager.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Tag and Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Academic Year Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  academicYear.toUpperCase(),
                  style: isLight
                      ? AppLightTextStyles.labelSmall.copyWith(
                    color: ColorsManager.blue,
                    fontWeight: FontWeight.w600,
                  )
                      : AppDarkTextStyles.labelSmall.copyWith(
                    color: ColorsManager.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Course Icon
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  courseIcon,
                  color: ColorsManager.blue,
                  size: 20.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Course Title
          Text(
            courseName,
            style: isLight
                ? AppLightTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)
                : AppDarkTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 12.h),

          // Details Row (Students & Time)
          Row(
            children: [
              Icon(Icons.people_outline, size: 16.sp, color: ColorsManager.grayMedium),
              SizedBox(width: 4.w),
              Text(
                studentsCount,
                style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
              ),
              SizedBox(width: 16.w),
              Icon(Icons.access_time, size: 16.sp, color: ColorsManager.grayMedium),
              SizedBox(width: 4.w),
              Text(
                timeString,
                style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Replaced with CustomElevatedButton
          CustomElevatedButton(
            label: 'Manage Course',
            onTap: onManageTap,
            backgroundColor: ColorsManager.blue,
            radius: 12.r, // Matches previous styling
            verticalPadding: 14.h, // Matches previous styling
          ),
        ],
      ),
    );
  }
}