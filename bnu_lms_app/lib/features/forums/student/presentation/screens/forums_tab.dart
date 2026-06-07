import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';
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

  List<ForumsData> coursesForums = [
    ForumsData(
      title: 'Introduction to Engineering',
      description: '12 posts, 5 participants',
      image: 'assets/images/programming.png',
    ),
    ForumsData(
      title: 'Calculus I',
      description: '8 posts, 3 participants',
      image: 'assets/images/calculus.png',
    ),
    ForumsData(
      title: 'Physics for Engineers',
      description: '15 posts, 7 participants',
      image: 'assets/images/linear_algebra.png',
    ),
  ];

  List<ForumsData> generalForums = [
    ForumsData(
      title: 'Campus Life',
      description: '20 posts, 10 participants',
      image: 'assets/images/data_structures.png',
    ),
    ForumsData(
      title: 'Study Groups',
      description: '5 posts, 2 participants',
      image: 'assets/images/programming.png',
    ),
  ];

  late List<ForumsData> filteredCoursesForums;
  late List<ForumsData> filteredGeneralForums;

  void filteredForumsSearch() {
    String query = searchController.text;
    if (query.isEmpty) {
      filteredCoursesForums = coursesForums;
      filteredGeneralForums = generalForums;
    } else {
      filteredCoursesForums = coursesForums
          .where(
            (forumData) =>
                forumData.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      filteredGeneralForums = generalForums
          .where(
            (forumData) =>
                forumData.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    filteredCoursesForums = coursesForums;
    filteredGeneralForums = generalForums;
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
            child: ForumSearch(searchController, filteredForumsSearch),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (filteredCoursesForums.isNotEmpty) ...[
                    _buildSectionHeader('Courses', isLight),
                    ...filteredCoursesForums.map(
                      (forum) => ForumCard(forum: forum),
                    ),
                  ],
                  if (filteredGeneralForums.isNotEmpty) ...[
                    _buildSectionHeader('General', isLight),
                    ...filteredGeneralForums.map(
                      (forum) => ForumCard(forum: forum),
                    ),
                  ],
                  if (filteredCoursesForums.isEmpty &&
                      filteredGeneralForums.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(32),
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
                    ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: ColorsManager.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isLight) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: isLight
            ? AppLightTextStyles.labelLarge.copyWith(
                color: ColorsManager.black,
                fontWeight: FontWeight.bold,
              )
            : AppDarkTextStyles.labelLarge.copyWith(
                color: ColorsManager.darkTextPrimary,
                fontWeight: FontWeight.bold,
              ),
      ),
    );
  }
}
