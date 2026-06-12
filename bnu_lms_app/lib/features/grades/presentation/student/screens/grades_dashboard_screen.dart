import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import 'package:bnu_lms_app/features/courses/presentation/cubit/courses_cubit/courses_state.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bnu_lms_app/features/profile/presentation/cubit/profile_state.dart';
import '../../widgets/shared_grades_widgets.dart';
import 'student_course_grades_screen.dart';

class GradesDashboardScreen extends StatefulWidget {
  const GradesDashboardScreen({super.key});

  @override
  State<GradesDashboardScreen> createState() => _GradesDashboardScreenState();
}

class _GradesDashboardScreenState extends State<GradesDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CoursesCubit>().fetchEnrolledCourses();
    // Try to load profile if not already loaded to get the name, but not strictly required
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return Scaffold(
      backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
      appBar: AppBar(
        title: Text(
          'Academic Clarity', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          )
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesError) {
            return Center(child: Text(state.message));
          } else if (state is CoursesLoaded) {
            final courses = state.courses;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CoursesCubit>().fetchEnrolledCourses();
                context.read<ProfileCubit>().fetchProfile();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, isDarkMode),
                    const SizedBox(height: 24),
                    ...courses.map((course) {
                      // Using UI placeholders for specific grades since GetEnrolledCourses doesn't return them
                      // The real grades are fetched in StudentCourseGradesScreen
                      return _buildCourseCard(
                        context,
                        isDarkMode,
                        courseCode: 'CS-${course.id}00',
                        courseTitle: course.title,
                        instructorName: course.instructorName,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentCourseGradesScreen(course: course),
                            ),
                          );
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String name = "Student";
        if (state is ProfileLoaded) {
          name = state.profile.firstName;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACADEMIC PERFORMANCE',
              style: TextStyle(
                color: ColorsManager.blue,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Good evening, $name',
              style: TextStyle(
                color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Current Semester Grades',
              style: TextStyle(
                color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildCourseCard(
    BuildContext context,
    bool isDarkMode, {
    required String courseCode,
    required String courseTitle,
    required String instructorName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDarkMode
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PillBadge(
                  text: courseCode,
                  backgroundColor: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  textColor: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              courseTitle,
              style: TextStyle(
                color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Instructor: $instructorName',
              style: TextStyle(
                color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Tap to view grading details',
                  style: TextStyle(
                    color: ColorsManager.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 10, color: ColorsManager.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildProgressBar({required String label, required double current, required double max, required bool isDarkMode}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(
  //           color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
  //           fontSize: 11,
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         '${current.toInt()}/${max.toInt()}',
  //         style: TextStyle(
  //           color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
  //           fontSize: 13,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       HorizontalProgressBar(
  //         current: current,
  //         max: max,
  //         color: ColorsManager.blue,
  //         backgroundColor: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
  //       ),
  //     ],
  //   );
  // }
}
