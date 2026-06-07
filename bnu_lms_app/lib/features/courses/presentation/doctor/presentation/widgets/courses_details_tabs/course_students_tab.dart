import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class CourseStudentsTab extends StatelessWidget {
  const CourseStudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class Roster',
                    style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '42 Students Enrolled',
                    style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkBlue ,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sort, size: 16.sp, color: ColorsManager.blue),
                    SizedBox(width: 4.w),
                    Text(
                      'Sort',
                      style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),

          // Student List
          _buildStudentItem(context, 'Alex Thompson', 'ID: 202300145', 'A-', 0.88, ColorsManager.blue),
          _buildStudentItem(context, 'Sarah Jenkins', 'ID: 202300089', 'A+', 0.98, ColorsManager.green),
          _buildStudentItem(context, 'Michael Chen', 'ID: 202300210', 'B', 0.72, ColorsManager.yellow),
          _buildStudentItem(context, 'David Miller', 'ID: 202300102', 'B+', 0.81, ColorsManager.blue),
        ],
      ),
    );
  }

  Widget _buildStudentItem(BuildContext context, String name, String id, String grade, double attendance, Color gradeColor) {
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
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                child: Icon(Icons.person, color: ColorsManager.grayMedium),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                    Text(id, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
                  ],
                ),
              ),
              // Grade Badge
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  grade,
                  style: AppLightTextStyles.labelMedium.copyWith(color: gradeColor, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(height: 16.h),
          // Attendance Bar
          Row(
            children: [
              Text('ATTENDANCE', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.sp)),
              SizedBox(width: 12.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: attendance,
                    backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(ColorsManager.blue),
                    minHeight: 6.h,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text('${(attendance * 100).toInt()}%', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
            ],
          )
        ],
      ),
    );
  }
}