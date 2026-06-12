import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/routes_manager/routes.dart';
import '../widgets/courses/course_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/di/injection.dart';
import '../../cubit/courses_cubit/courses_cubit.dart';
import '../../cubit/courses_cubit/courses_state.dart';



class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CoursesCubit>()..fetchEnrolledCourses(),
      child: const _CoursesTabView(),
    );
  }
}

class _CoursesTabView extends StatelessWidget {
  const _CoursesTabView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.courses,
                  style: isLight
                      ? AppLightTextStyles.headlineLarge
                      : AppDarkTextStyles.headlineLarge,
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Show semester picker
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isLight ? const Color(0xFFB8E9F5) : ColorsManager.darkSurface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fall 2024',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF00A3CC),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: const Color(0xFF00A3CC),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Course List
          Expanded(
            child: BlocBuilder<CoursesCubit, CoursesState>(
              builder: (context, state) {
                if (state is CoursesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CoursesError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: ColorsManager.red, fontSize: 16),
                    ),
                  );
                } else if (state is CoursesLoaded) {
                  final courses = state.courses;
                  if (courses.isEmpty) {
                    return Center(
                      child: Text(
                        'You are not enrolled in any courses.',
                        style: TextStyle(color: ColorsManager.grayDark, fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      // UI defaults since API doesn't have them yet
                      const categoryColor = Color(0xFF5DADE2);
                      final iconBgColor = isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049);
                      const icon = Icons.computer;

                      return CourseCard(
                        title: course.title,
                        instructor: course.instructorName,
                        category: 'Computer Science',
                        categoryColor: categoryColor,
                        iconBgColor: iconBgColor,
                        categoryIcon: icon,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.coursesDetails,
                            arguments: {
                              'courseId': course.id, // passing ID to details screen
                              'courseTitle': course.title,
                              'instructor': course.instructorName,
                              'courseCode': 'SWE-301',
                              'icon': icon,
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}