import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:flutter/material.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Center(
              child: Text(
                'Profile',
                style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
              ),
            ),
          ),

          // Added spacing
          SizedBox(height: AppSizes.largeSpacing),

          // 2. Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Column(
                children: [
                  const DoctorProfileHeader(),
                  SizedBox(height: 24.0),
                  const ContactAndStats(),
                  SizedBox(height: 32.0),
                  const MyCoursesSection(),
                  SizedBox(height: 24.0),
                  const OfficeHoursCard(),
                  SizedBox(height: 32.0),
                  const SettingsSection(),
                  SizedBox(height: 40.0), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}