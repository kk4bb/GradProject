import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';


class CourseAttendanceTab extends StatelessWidget {
  const CourseAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Take Attendance Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: ColorsManager.blue,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(color: ColorsManager.blue.withValues(alpha: 0.3), blurRadius: 12.r, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.how_to_reg, color: ColorsManager.white, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Take Attendance',
                  style: AppDarkTextStyles.labelLarge.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance History',
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
              ),
              Text(
                'Monthly View',
                style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          _buildAttendanceCard(context, 'Monday, Oct 24', 'Session #12 • Lecture', 92, 8),
          _buildAttendanceCard(context, 'Monday, Oct 17', 'Session #11 • Lab', 88, 12),
          _buildAttendanceCard(context, 'Monday, Oct 10', 'Session #10 • Lecture', 95, 5),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, String date, String sessionInfo, int present, int absent) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8.r, offset: const Offset(0, 2))]
            : [],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                  SizedBox(height: 4.h),
                  Text(sessionInfo, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorsManager.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'COMPLETED',
                  style: AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.blue, fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('$present%', style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(color: ColorsManager.blue)),
                  SizedBox(width: 8.w),
                  Text('PRESENT', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.sp)),
                  SizedBox(width: 20.w),
                  Text('$absent%', style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(color: ColorsManager.red)),
                  SizedBox(width: 8.w),
                  Text('ABSENT', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.sp)),
                ],
              ),
              Text('Details >', style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.grayMedium)),
            ],
          ),
        ],
      ),
    );
  }
}