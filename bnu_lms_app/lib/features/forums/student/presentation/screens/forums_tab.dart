import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/network/repositories/course_repository.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../courses/data/models/course_model.dart';
import '../../../data/forums_data.dart';
import '../widgets/fourms/forum_card.dart';
import '../widgets/fourms/forum_search.dart';

class ForumsTab extends StatefulWidget {
  const ForumsTab({super.key});

  @override
  State<ForumsTab> createState() => _ForumsTabState();
}

class _ForumsTabState extends State<ForumsTab> {
  TextEditingController searchController = TextEditingController();
  final CourseRepository _courseRepository = CourseRepository();
  late Future<List<CourseSummary>> _coursesFuture;
  List<CourseSummary> _allCourses = [];
  List<CourseSummary> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseRepository.getEnrolledCourses();
  }

  void filteredForumsSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = _allCourses;
      } else {
        _filteredCourses = _allCourses
            .where(
              (course) =>
                  course.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight
          ? ColorsManager.lightBackground
          : ColorsManager.darkBackground,
      appBar: AppBar(
        title: Text(
          localization.forums,
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isLight
            ? ColorsManager.white
            : ColorsManager.darkSurface,
      ),
      body: Column(
        children: [
          Container(
            color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
            child: ForumSearch(searchController, () => filteredForumsSearch(searchController.text)),
          ),
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

                _allCourses = snapshot.data!;
                if (searchController.text.isEmpty) {
                  _filteredCourses = _allCourses;
                }

                if (_filteredCourses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No forums found',
                        style: TextStyle(
                          color: isLight
                              ? ColorsManager.grayMedium
                              : ColorsManager.darkTextSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = _filteredCourses[index];
                    return ForumCard(
                      forum: ForumsData(
                        title: course.title,
                        description: 'Course Discussions',
                        image: _getImageForCourse(course.title),
                        courseId: course.id,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: ColorsManager.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getImageForCourse(String title) {
    title = title.toLowerCase();
    if (title.contains('calculus')) return 'assets/images/calculus.png';
    if (title.contains('programming')) return 'assets/images/programming.png';
    if (title.contains('physics')) return 'assets/images/linear_algebra.png';
    return 'assets/images/data_structures.png';
  }
}

