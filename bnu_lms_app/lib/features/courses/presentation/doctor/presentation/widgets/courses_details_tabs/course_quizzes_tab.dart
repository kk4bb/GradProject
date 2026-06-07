import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';



class CourseQuizzesTab extends StatelessWidget {
  const CourseQuizzesTab({super.key});

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
                'Active Assessments',
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: ColorsManager.white, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Create',
                      style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          _buildQuizCard(context, 'Midterm Quiz 1', 'Created Oct 12, 2023', 'ACTIVE', ColorsManager.blue, '60 Mins', '30 Questions', 'View Results >'),
          _buildQuizCard(context, 'Pop Quiz: UI Design', 'Created Yesterday', 'DRAFT', ColorsManager.grayMedium, '15 Mins', '10 Questions', 'Continue Editing >', icon: Icons.edit),
          _buildQuizCard(context, 'Final Assessment', 'Scheduled for Dec 15', 'SCHEDULED', ColorsManager.blueGray, '120 Mins', '50 Questions', 'Manage Settings >', icon: Icons.settings),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, String title, String subtitle, String status, Color statusColor, String duration, String questions, String actionText, {IconData? icon}) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  status,
                  style: AppLightTextStyles.labelSmall.copyWith(color: statusColor, fontSize: 10.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(subtitle, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16.sp, color: ColorsManager.blue),
              SizedBox(width: 4.w),
              Text(duration, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
              SizedBox(width: 16.w),
              Icon(Icons.quiz_outlined, size: 16.sp, color: ColorsManager.blue),
              SizedBox(width: 4.w),
              Text(questions, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
            ],
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14.sp, color: ColorsManager.grayMedium),
                  SizedBox(width: 4.w),
                ],
                Text(
                  actionText,
                  style: AppLightTextStyles.labelMedium.copyWith(color: isLight ? ColorsManager.grayDark : ColorsManager.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}