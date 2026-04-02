import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: REdgeInsets.all(22),
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
          SizedBox(height: 16.h),
          DoctorCourseCard(
            academicYear: 'Academic Year 2023/24',
            courseName: 'Advanced Structural Engineering',
            studentsCount: '120 Students',
            timeString: 'Today, 10:00 AM',
            courseIcon: Icons.engineering_outlined,
            onManageTap: () {},
          ),
          SizedBox(height: 16.h),
          DoctorCourseCard(
            academicYear: 'Academic Year 2023/24',
            courseName: 'Intro to Neural Networks',
            studentsCount: '85 Students',
            timeString: 'Tomorrow, 02:00 PM',
            courseIcon: Icons.psychology_outlined,
            onManageTap: () {},
          ),
        ],
      ),
    );
  }
}