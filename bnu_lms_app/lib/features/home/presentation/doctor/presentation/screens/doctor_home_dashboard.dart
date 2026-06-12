import 'package:flutter/material.dart';


import 'package:bnu_lms_app/shared/resources/app_sizes.dart';

// Import the separated section widgets
import '../widgets/doctor_dashboard_top_header.dart';
import '../widgets/doctor_stats_grid.dart';
import '../widgets/teaching_tools_section.dart';

class DoctorHomeDashboard extends StatelessWidget {
  const DoctorHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final isLight = themeProvider.isLightTheme();

    return SingleChildScrollView(
      child: Column(
        children: [
          const DoctorDashboardTopHeader(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DoctorStatsGrid(),

              SizedBox(height: AppSizes.largeSpacing),

              const TeachingToolsSection(isInstructor: true),

              SizedBox(height: AppSizes.largeSpacing),

            ],
          ),
        ],
      ),
    );
  }
}