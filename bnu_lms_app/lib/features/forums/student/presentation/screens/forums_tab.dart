import 'package:bnu_lms_app/features/courses/data/models/course_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';

class ForumsTab extends StatefulWidget {
  const ForumsTab({super.key});

  @override
  State<ForumsTab> createState() => _ForumsTabState();
}

class _ForumsTabState extends State<ForumsTab> {
  TextEditingController searchController = TextEditingController();
  final CourseRepository _courseRepository = CourseRepository();
  List<CourseSummary> _allCourses = [];
  List<CourseSummary> _filteredCourses = [];
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
        _allCourses = courses;
        _filteredCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterForums(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = _allCourses;
      } else {
        _filteredCourses = _allCourses
            .where((course) => course.title.toLowerCase().contains(query.toLowerCase()))
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
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        title: Text(localization.forums, style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterForums,
              decoration: InputDecoration(
                hintText: 'Search course forums...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isLight ? Colors.white : ColorsManager.darkSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : ListView.builder(
                        itemCount: _filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = _filteredCourses[index];
                          return _buildForumCard(context, course, isLight);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumCard(BuildContext context, CourseSummary course, bool isLight) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.forumsDetails,
          arguments: {
            'forumTitle': course.title,
            'courseId': course.id,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isLight
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ColorsManager.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.forum_outlined, color: ColorsManager.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Join the discussion',
                    style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: ColorsManager.grayMedium),
          ],
        ),
      ),
    );
  }
}
