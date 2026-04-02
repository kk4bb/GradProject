import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';

// Import the extracted widgets
import '../widgets/doctor_profile_header.dart';
import '../widgets/contact_and_stats.dart';
import '../widgets/my_courses_section.dart';
import '../widgets/office_hours_card.dart';
import '../widgets/settings_section.dart';

class DoctorProfileTab extends StatelessWidget {
  const DoctorProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Custom Header (Removed the Row to perfectly center the title)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Center(
              child: Text(
                'Profile',
                style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
              ),
            ),
          ),

          // Added .h here just in case AppSizes.largeSpacing is a raw double
          SizedBox(height: AppSizes.largeSpacing.h),

          // 2. Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
              child: Column(
                children: [
                  const DoctorProfileHeader(),
                  SizedBox(height: 24.h),
                  const ContactAndStats(),
                  SizedBox(height: 32.h),
                  const MyCoursesSection(),
                  SizedBox(height: 24.h),
                  const OfficeHoursCard(),
                  SizedBox(height: 32.h),
                  const SettingsSection(),
                  SizedBox(height: 40.h), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}