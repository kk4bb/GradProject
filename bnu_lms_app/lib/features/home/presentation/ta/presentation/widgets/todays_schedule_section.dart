import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class TodaysScheduleSection extends StatelessWidget {
  const TodaysScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: REdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Schedule",
                style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
              ),
              Text(
                'Oct 24, 2023',
                style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          _buildTimelineItem(
            context, isLight,
            time: '09:00',
            type: 'LAB SESSION',
            title: 'Data Structures (Section B)',
            location: 'Lab Room 402',
            accentColor: const Color(0xFF2FBAD7), // Cyan
          ),
          _buildTimelineItem(
            context, isLight,
            time: '11:30',
            type: 'OFFICE HOURS',
            title: 'Student Consultation',
            location: 'Zoom Meeting',
            accentColor: ColorsManager.grayMedium,
          ),
          _buildTimelineItem(
            context, isLight,
            time: '14:00',
            type: 'LECTURE ASST.',
            title: 'Intro to Algorithms',
            location: 'Main Auditorium',
            accentColor: ColorsManager.lightBlueAccent, // Using a lighter blue
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      BuildContext context,
      bool isLight, {
        required String time,
        required String type,
        required String title,
        required String location,
        required Color accentColor,
      }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          SizedBox(
            width: 50.w,
            child: Text(
              time,
              style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // Timeline Line
          Container(
            width: 2.w,
            color: ColorsManager.grayMedium.withValues(alpha: 0.3),
            margin: EdgeInsets.only(right: 16.w),
          ),

          // Card Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isLight ? const Color(0xFFF8F9FA) : ColorsManager.darkSurface, // Slightly darker for card
                borderRadius: BorderRadius.circular(12.r),
                // Custom left border for the accent color
                border: Border(
                  left: BorderSide(color: accentColor, width: 4.w),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: AppLightTextStyles.labelSmall.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14.sp, color: ColorsManager.grayMedium),
                      SizedBox(width: 4.w),
                      Text(
                        location,
                        style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}