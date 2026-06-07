import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class CourseAssignmentsTab extends StatelessWidget {
  const CourseAssignmentsTab({super.key});

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
                'Active Assignments',
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
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
              ),
            ],
          ),
          SizedBox(height: 20.h),

          _buildAssignmentCard(context, 'Midterm Project Proposal', 'Due: Oct 24, 2023 • 11:59 PM', 'ACTIVE', ColorsManager.blue, 28, 30),
          _buildAssignmentCard(context, 'Weekly Quiz 4: User Research', 'Due: Oct 18, 2023 • 10:00 AM', 'GRADED', ColorsManager.green, 30, 30),
          _buildAssignmentCard(context, 'Final Research Paper', 'Due: Dec 12, 2023 • 11:59 PM', 'DRAFT', ColorsManager.grayMedium, 0, 30),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, String title, String dueDate, String status, Color statusColor, int submitted, int total) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    double progress = total > 0 ? submitted / total : 0;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12.sp, color: ColorsManager.grayMedium),
                        SizedBox(width: 4.w),
                        Text(dueDate, style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 11.sp)),
                      ],
                    ),
                  ],
                ),
              ),
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
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SUBMISSIONS', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.sp)),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text('$submitted', style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                      Text('/$total', style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 16.sp, color: ColorsManager.grayMedium),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 4.h,
            ),
          ),
        ],
      ),
    );
  }
}