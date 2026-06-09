import 'package:bnu_lms_app/features/courses/data/models/course_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../home/presentation/doctor/presentation/widgets/doctor_course_card.dart';

class DoctorCoursesTab extends StatefulWidget {
  const DoctorCoursesTab({super.key});

  @override
  State<DoctorCoursesTab> createState() => _DoctorCoursesTabState();
}

class _DoctorCoursesTabState extends State<DoctorCoursesTab> {
  final CourseRepository _courseRepository = CourseRepository();
  List<CourseSummary> _courses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final courses = await _courseRepository.getAssignedCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          localizations.courses,
                          style: isLight
                              ? AppLightTextStyles.headlineLarge
                              : AppDarkTextStyles.headlineLarge,
                        ),
                        SizedBox(height: AppSizes.largeSpacing),
                        // Course Cards List
                        ..._courses.map((course) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: DoctorCourseCard(
                                academicYear: 'Academic Year 2023/24', // TODO: Fetch from API if available
                                courseName: course.title,
                                studentsCount: '0 Students', // TODO: Fetch count from API
                                timeString: 'N/A', // TODO: Fetch schedule from API
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
                  ),
                ),
    );
  }
}
