import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../home/presentation/doctor/presentation/widgets/doctor_course_card.dart';

class DoctorCoursesTab extends StatelessWidget {
  const DoctorCoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:  REdgeInsets.symmetric(horizontal: 16.0,vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localizations.courses,
                style: isLight
                    ? AppLightTextStyles.headlineLarge
                    : AppDarkTextStyles.headlineLarge,
              ),
              SizedBox(height: AppSizes.largeSpacing),
              // Course Cards List
              DoctorCourseCard(
                academicYear: 'Academic Year 2023/24',
                courseName: 'Advanced Structural Engineering',
                studentsCount: '120 Students',
                timeString: 'Today, 10:00 AM',
                courseIcon: Icons.engineering_outlined,
                onManageTap: () {
                  Navigator.pushNamed(context, Routes.taCoursesDetails);
                },
              ),
        
              SizedBox(height: 16.h), // Space between cards
        
              DoctorCourseCard(
                academicYear: 'Academic Year 2023/24',
                courseName: 'Intro to Neural Networks',
                studentsCount: '85 Students',
                timeString: 'Tomorrow, 02:00 PM',
                courseIcon: Icons.psychology_outlined,
                onManageTap: () {
                  // TODO: Action for Manage Course
                },
              ),
              SizedBox(height: 16.h),
              DoctorCourseCard(
                academicYear: 'Academic Year 2023/24',
                courseName: 'Intro to Neural Networks',
                studentsCount: '85 Students',
                timeString: 'Tomorrow, 02:00 PM',
                courseIcon: Icons.psychology_outlined,
                onManageTap: () {
                  // TODO: Action for Manage Course
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
