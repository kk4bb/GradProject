import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../home/presentation/doctor/presentation/widgets/doctor_course_card.dart';
import '../../../../../../shared/network/repositories/course_repository.dart';
import '../../../../data/models/course_model.dart';

class DoctorCoursesTab extends StatefulWidget {
  const DoctorCoursesTab({super.key});

  @override
  State<DoctorCoursesTab> createState() => _DoctorCoursesTabState();
}

class _DoctorCoursesTabState extends State<DoctorCoursesTab> {
  final CourseRepository _courseRepository = CourseRepository();
  late Future<List<CourseSummary>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseRepository.getAssignedCourses();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return SafeArea(
      child: FutureBuilder<List<CourseSummary>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final courses = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
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
                  
                  if (courses.isEmpty)
                    const Center(child: Text('No assigned courses found.'))
                  else
                    ...courses.map((course) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DoctorCourseCard(
                        academicYear: 'Academic Year 2023/24', // Could be dynamic if API provides it
                        courseName: course.title,
                        studentsCount: 'Manage this course', // Or real count if available
                        timeString: '', // Could be next lecture time
                        courseIcon: Icons.engineering_outlined,
                        onManageTap: () {
                          Navigator.pushNamed(
                            context, 
                            Routes.doctorCoursesDetails,
                            arguments: {
                              'courseId': course.id,
                              'courseTitle': course.title,
                            }
                          );
                        },
                      ),
                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
