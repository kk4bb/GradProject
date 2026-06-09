import 'package:bnu_lms_app/features/courses/data/models/course_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import 'doctor_course_card.dart';

class DoctorMyCoursesSection extends StatefulWidget {
  const DoctorMyCoursesSection({super.key});

  @override
  State<DoctorMyCoursesSection> createState() => _DoctorMyCoursesSectionState();
}

class _DoctorMyCoursesSectionState extends State<DoctorMyCoursesSection> {
  final CourseRepository _courseRepository = CourseRepository();
  List<CourseSummary> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final courses = await _courseRepository.getAssignedCourses();
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: const EdgeInsets.all(22),
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
                onTap: () {
                  // Navigate to Courses Tab in Home
                },
                child: Text(
                  'View All',
                  style: isLight
                      ? AppLightTextStyles.titleMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.w600)
                      : AppDarkTextStyles.titleMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_courses.isEmpty)
            const Center(child: Text('No assigned courses found'))
          else
            ..._courses.take(2).map((course) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DoctorCourseCard(
                    academicYear: 'Academic Year 2023/24',
                    courseName: course.title,
                    studentsCount: '0 Students', // TODO: Fetch from API
                    timeString: 'N/A', // TODO: Fetch from API
                    courseIcon: Icons.engineering_outlined,
                    onManageTap: () {
                       Navigator.pushNamed(
                        context,
                        Routes.doctorCoursesDetails,
                        arguments: {'courseId': course.id},
                      );
                    },
                  ),
                )),
        ],
      ),
    );
  }
}