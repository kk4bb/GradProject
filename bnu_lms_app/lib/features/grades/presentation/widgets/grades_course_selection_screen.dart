import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import 'package:bnu_lms_app/features/courses/presentation/cubit/courses_cubit/courses_state.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';

import '../../../../shared/di/injection.dart';
import '../instructor/screens/instructor_class_overview_screen.dart';
import '../ta/screens/ta_students_list_screen.dart';

class GradesCourseSelectionScreen extends StatefulWidget {
  final bool isInstructor;

  const GradesCourseSelectionScreen({super.key, required this.isInstructor});

  @override
  State<GradesCourseSelectionScreen> createState() => _GradesCourseSelectionScreenState();
}

class _GradesCourseSelectionScreenState extends State<GradesCourseSelectionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return Scaffold(
      backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
      appBar: AppBar(
        title: const Text('Select Course', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDarkMode ? ColorsManager.white : ColorsManager.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (_) => getIt<CoursesCubit>()..fetchAssignedCourses(),
        child: BlocBuilder<CoursesCubit, CoursesState>(
          builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesError) {
            return Center(child: Text(state.message));
          } else if (state is CoursesLoaded) {
            final courses = state.courses;
            if (courses.isEmpty) {
              return const Center(child: Text('No courses assigned.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return GestureDetector(
                  onTap: () {
                    if (widget.isInstructor) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InstructorClassOverviewScreen(
                            course: course,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaStudentsListScreen(
                            course: course,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.class_, color: ColorsManager.blue, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.title,
                                style: TextStyle(
                                  color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Course ID: ${course.id}',
                                style: TextStyle(
                                  color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  }
}
