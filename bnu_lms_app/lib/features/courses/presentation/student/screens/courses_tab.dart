import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/network/repositories/course_repository.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../data/models/course_model.dart';
import '../widgets/courses/course_card.dart';

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  final CourseRepository _courseRepository = CourseRepository();
  late Future<List<CourseSummary>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseRepository.getEnrolledCourses();
  }

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
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isLight ? const Color(0xFFB8E9F5) : ColorsManager.darkSurface,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fall 2024',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00A3CC),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF00A3CC),
                          size: 20.0,
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
            child: FutureBuilder<List<CourseSummary>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final courses = snapshot.data!;
                if (courses.isEmpty) {
                  return const Center(child: Text('No enrolled courses found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(
                      course: course,
                      categoryIcon: _getIconForCourse(course.title),
                    );
                  },
                );
              },
            ),
          ),
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
    return Icons.book;
  }
}
