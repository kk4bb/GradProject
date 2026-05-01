import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../data/models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseSummary course;
  final Color categoryColor;
  final IconData categoryIcon;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
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
            'courseId': course.id,
            'courseTitle': course.title,
            'instructor': course.instructorName,
            'icon': categoryIcon,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(20.0),
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
                        course.title,
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
                      const SizedBox(height: 8.0),
                      Text(
                        course.instructorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: isLight
                            ? AppLightTextStyles.bodySmall
                            : AppDarkTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: isLight ? iconBgColor : const Color(0xFF223049),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(categoryIcon, size: 28.0, color: categoryColor),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "Computer Science", // Dynamic category could be added to DTO if needed
                style: TextStyle(
                  fontSize: 12.0,
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
