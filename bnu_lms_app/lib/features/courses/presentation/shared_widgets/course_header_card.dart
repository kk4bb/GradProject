import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';

class CourseHeaderCard extends StatelessWidget {
  final String title;
  final String instructor;
  final String courseCode;
  final IconData icon;

  const CourseHeaderCard({
    required this.title,
    required this.instructor,
    required this.courseCode,
    this.icon = Icons.computer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      margin: REdgeInsets.all(16),
      padding: REdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isLight
            ? LinearGradient(
          colors: [
            ColorsManager.lightBlueAccent,
            ColorsManager.lightBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : LinearGradient(
          colors: [
            ColorsManager.darkSurface,
            ColorsManager.darkBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: isLight
            ? null
            : Border.all(
          color: ColorsManager.blue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? ColorsManager.black
                        : ColorsManager.darkTextPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  instructor,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: isLight
                        ? ColorsManager.grayDark
                        : ColorsManager.darkTextSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Course Code: $courseCode',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isLight
                        ? ColorsManager.grayDark
                        : ColorsManager.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: ColorsManager.blue.withValues(alpha:  isLight ? 0.2 : 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40.sp,
              color: ColorsManager.blue,
            ),
          ),
        ],
      ),
    );
  }
}