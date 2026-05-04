import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/resources/app_sizes.dart';
import '../../../../../../shared/routes_manager/routes.dart';
import 'doctor_course_card.dart';

import '../../../../../courses/data/models/course_model.dart';

class DoctorMyCoursesSection extends StatelessWidget {
  final List<CourseSummary> courses;
  const DoctorMyCoursesSection({required this.courses, super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: EdgeInsets.all(AppSizes.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'My Courses',
                style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: isLight
                      ? AppLightTextStyles.titleMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.w600)
                      : AppDarkTextStyles.titleMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          if (courses.isEmpty)
            const Center(child: Text('No assigned courses found.'))
          else
            ...courses.map((course) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DoctorCourseCard(
                academicYear: 'Academic Year 2023/24',
                courseName: course.title,
                studentsCount: 'Manage this course',
                timeString: 'Assigned',
                courseIcon: _getIconForCourse(course.title),
                onManageTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.doctorCoursesDetails,
                    arguments: {
                      'courseId': course.id,
                      'courseTitle': course.title,
                    },
                  );
                },
              ),
            )),
        ],
      ),
    );
  }

  IconData _getIconForCourse(String title) {
    title = title.toLowerCase();
    if (title.contains('mobile')) return Icons.phone_android;
    if (title.contains('web')) return Icons.language;
    if (title.contains('data science') || title.contains('intelligence')) return Icons.psychology;
    if (title.contains('database') || title.contains('cloud')) return Icons.storage;
    if (title.contains('programming') || title.contains('code')) return Icons.code;
    return Icons.engineering_outlined;
  }
}
