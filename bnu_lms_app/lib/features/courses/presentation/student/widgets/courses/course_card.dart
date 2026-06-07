
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';



class CourseCard extends StatelessWidget {
  final String title;
  final String instructor;
  final String category;
  final Color categoryColor;
  final IconData categoryIcon;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    this.title = "Mobile App Development",
    this.instructor = "Dr. Ahmed Hassan",
    this.category = "Computer Science",
    this.categoryColor = const Color(0xFF5DADE2),
    this.categoryIcon = Icons.computer,
    this.iconBgColor = const Color(0xFFD6EAF8),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.pushNamed(
          context,
          Routes.coursesDetails,
          arguments: {
            'courseTitle': title,
            'instructor': instructor,
            'courseCode': 'SWE-301',
            'icon': categoryIcon,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: isLight
                            ? AppLightTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        )
                            : AppDarkTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        instructor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: isLight
                            ? AppLightTextStyles.bodySmall
                            : AppDarkTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(categoryIcon, size: 28.sp, color: categoryColor),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: categoryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}