import 'package:flutter/material.dart';
import 'package:bnu_lms_app/shared/resources/app_sizes.dart';

// Import the separated section widgets
import '../widgets/doctor_dashboard_top_header.dart';
import '../widgets/doctor_stats_grid.dart';
import '../widgets/doctor_quick_access_section.dart';
import '../widgets/doctor_my_courses_section.dart';

class DoctorHomeDashboard extends StatelessWidget {
  const DoctorHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const DoctorDashboardTopHeader(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DoctorStatsGrid(),

              SizedBox(height: AppSizes.largeSpacing),

              const DoctorQuickAccessSection(),

              const DoctorMyCoursesSection(),
            ],
          ),
        ],
      ),
    );
  }
}