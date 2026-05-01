import 'package:flutter/material.dart';
import 'package:bnu_lms_app/shared/resources/app_sizes.dart';

// Import the separated section widgets
import '../widgets/doctor_dashboard_top_header.dart';
import '../widgets/doctor_stats_grid.dart';
import '../widgets/doctor_quick_access_section.dart';
import '../widgets/doctor_my_courses_section.dart';

import '../../../../../../shared/network/repositories/course_repository.dart';
import '../../../../../../features/courses/data/models/course_model.dart';

class DoctorHomeDashboard extends StatefulWidget {
  const DoctorHomeDashboard({super.key});

  @override
  State<DoctorHomeDashboard> createState() => _DoctorHomeDashboardState();
}

class _DoctorHomeDashboardState extends State<DoctorHomeDashboard> {
  final CourseRepository _courseRepository = CourseRepository();
  late Future<List<CourseSummary>> _assignedCoursesFuture;

  @override
  void initState() {
    super.initState();
    _assignedCoursesFuture = _courseRepository.getAssignedCourses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseSummary>>(
      future: _assignedCoursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final courses = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            children: [
              const DoctorDashboardTopHeader(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorStatsGrid(courseCount: courses.length),

                  SizedBox(height: AppSizes.largeSpacing),

                  const DoctorQuickAccessSection(),

                  DoctorMyCoursesSection(courses: courses),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
