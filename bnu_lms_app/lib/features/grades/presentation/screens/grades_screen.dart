import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../widgets/gpa_badge.dart';
import '../widgets/grade_card.dart';
import '../widgets/semester_tabs.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: REdgeInsets.all(AppSizes.largeSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isLight, localizations),
              SizedBox(height: AppSizes.smallSpacing),
              GPABadge(isLight: isLight),
              SizedBox(height: AppSizes.mediumSpacing),
              SemesterTabs(isLight: isLight),
              SizedBox(height: AppSizes.largeSpacing),
              _buildTabContent(isLight),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorsManager.blue),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: REdgeInsets.all(AppSizes.mediumSpacing),
          child: IconButton(
            icon: const Icon(Icons.more_vert, color: ColorsManager.blue),
            onPressed: () {
              // TODO: Implement menu actions
            },
          ),
        ),
      ],
      elevation: 0,
    );
  }

  Widget _buildHeader(bool isLight, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.grades,
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
        SizedBox(height: 4.h),
        Text(
          'Your Academic Performance',
          style: isLight
              ? AppLightTextStyles.labelMedium
              : AppDarkTextStyles.labelMedium,
        ),
      ],
    );
  }

  Widget _buildTabContent(bool isLight) {
    return Expanded(
      child: TabBarView(
        children: [
          _buildFall2024Tab(isLight),
          _buildSpring2025Tab(isLight),
          _buildSummer2025Tab(isLight),
        ],
      ),
    );
  }

  Widget _buildFall2024Tab(bool isLight) {
    return ListView(
      children: [
        GradeCard(
          isLight: isLight,
          courseCode: 'CS101',
          courseTitle: 'Intro to Programming',
          instructor: 'Dr. Alan Turing',
          gradeLetter: 'A+',
          gradeColor: ColorsManager.green, // Green
          borderColor: ColorsManager.green, // Cyan
          scores: const [
            GradeScore(label: 'Class Work', earnedPoints: 29, totalPoints: 30),
            GradeScore(label: 'Midterm 1', earnedPoints: 13, totalPoints: 15),
            GradeScore(label: 'Midterm 2', earnedPoints: 13, totalPoints: 15),
            GradeScore(label: 'Final', earnedPoints: 37, totalPoints: 40),
          ],
        ),
        SizedBox(height: AppSizes.mediumSpacing,),
        GradeCard(
          isLight: isLight,
          courseCode: 'MATH203',
          courseTitle: 'Linear Algebra',
          instructor: 'Dr. Emmy Noether',
          gradeLetter: 'C+',
          gradeColor: const Color(0xFFFFA726), // Orange
          borderColor: const Color(0xFFFF9800), // Orange border
          scores: const [
            GradeScore(label: 'Class Work', earnedPoints: 24, totalPoints: 30),
            GradeScore(label: 'Midterm', earnedPoints: 11, totalPoints: 15),
            GradeScore(label: 'Final Exam', earnedPoints: 30, totalPoints: 40),
          ],
        ),
        SizedBox(height: AppSizes.mediumSpacing,),
        GradeCard(
          isLight: isLight,
          courseCode: 'PHYS110',
          courseTitle: 'Classical Mechanics',
          instructor: 'Dr. Isaac Newton',
          gradeLetter: 'D',
          gradeColor: const Color(0xFFE53935), // Red
          borderColor: const Color(0xFFF44336), // Red border
          scores: const [
            GradeScore(label: 'Labs', earnedPoints: 21, totalPoints: 30),
            GradeScore(label: 'Midterm', earnedPoints: 8, totalPoints: 15),
            GradeScore(label: 'Final', earnedPoints: 24, totalPoints: 40),
          ],
        ),
        SizedBox(height: AppSizes.mediumSpacing,),
        GradeCard(
          isLight: isLight,
          courseCode: 'ENG101',
          courseTitle: 'Academic Writing',
          instructor: 'Dr. Virginia Woolf',
          gradeLetter: 'IP',
          gradeColor: const Color(0xFF42A5F5), // Blue
          borderColor: const Color(0xFF2196F3), // Blue border
          scores: const [
            GradeScore(label: 'Essays', earnedPoints: 23, totalPoints: 30),
            GradeScore(label: 'Participation', earnedPoints: 12, totalPoints: 15),
            GradeScore(label: 'Final Paper', earnedPoints: 0, totalPoints: 40),
          ],
        ),
      ],
    );
  }
  Widget _buildSpring2025Tab(bool isLight) {
    return GradeCard(
      isLight: isLight,
      courseCode: 'PHYS110',
      courseTitle: 'Classical Mechanics',
      instructor: 'Dr. Isaac Newton',
      gradeLetter: 'D',
      gradeColor: const Color(0xFFE53935), // Red
      borderColor: const Color(0xFFF44336), // Red border
      scores: const [
        GradeScore(label: 'Labs', earnedPoints: 21, totalPoints: 30),
        GradeScore(label: 'Midterm', earnedPoints: 8, totalPoints: 15),
        GradeScore(label: 'Final', earnedPoints: 24, totalPoints: 40),
      ],
    );
  }

  Widget _buildSummer2025Tab(bool isLight) {
    return Center(
      child: Text(
        'Summer 2025 Grades',
        style: isLight
            ? AppLightTextStyles.bodyLarge
            : AppDarkTextStyles.bodyLarge,
      ),
    );
  }
}