import 'package:bnu_lms_app/features/courses/data/models/course_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/routes_manager/routes.dart';
import '../widgets/courses/course_card.dart';

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
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
      final courses = await _courseRepository.getEnrolledCourses();
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
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isLight ? Color(0xFFB8E9F5) : ColorsManager.darkSurface,
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
                          return CourseCard(
                            title: course.title,
                            instructor: course.instructorName,
                            category: 'Computer Science', // TODO: Fetch category if available
                            categoryColor: const Color(0xFF5DADE2),
                            iconBgColor: isLight ? const Color(0xFFdbeafe) : const Color(0xFF223049),
                            categoryIcon: Icons.computer, // TODO: Use dynamic icon
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.coursesDetails,
                                arguments: {
                                  'courseId': course.id,
                                  'courseTitle': course.title,
                                  'instructor': course.instructorName,
                                },
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
}