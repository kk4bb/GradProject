import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import 'doctor_course_card.dart';

class DoctorMyCoursesSection extends StatelessWidget {
  const DoctorMyCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'My Courses',
                style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: isLight
                      ? AppLightTextStyles.titleMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.w600)
                      : AppDarkTextStyles.titleMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          DoctorCourseCard(
            academicYear: 'Academic Year 2023/24',
            courseName: 'Advanced Structural Engineering',
            courseCode: 'ENG-402',
            instructorName: 'Dr. Emily Chen',
            courseIcon: Icons.engineering_outlined,
            onManageTap: () {},
          ),
          SizedBox(height: 16),
          DoctorCourseCard(
            academicYear: 'Academic Year 2023/24',
            courseName: 'Intro to Neural Networks',
            courseCode: 'CS-501',
            instructorName: 'Dr. Alan Turing',
            courseIcon: Icons.psychology_outlined,
            onManageTap: () {},
          ),
        ],
      ),
    );
  }
}