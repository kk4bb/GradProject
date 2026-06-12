import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/resources/app_sizes.dart';
import '../widgets/ta_stats_grid.dart';
import '../../../doctor/presentation/widgets/doctor_dashboard_header.dart';
import '../../../doctor/presentation/widgets/teaching_tools_section.dart';


class TaHomeDashboard extends StatelessWidget {
  const TaHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final isLight = themeProvider.isLightTheme();

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Reused Header (This keeps the white container + date pill look)
          // We can use the DoctorDashboardTopHeader directly if the text inside
          // isn't hardcoded to "Dr.". If it is, we wrap DoctorDashboardHeader manually.
          const _TaHeaderWrapper(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),

              // 2. Stats Grid (Labs, Grading, Forums)
              const TaStatsGrid(),

              SizedBox(height: AppSizes.largeSpacing),

              const TeachingToolsSection(isInstructor: false),



              SizedBox(height: 40), // Bottom padding
            ],
          ),
        ],
      ),
    );
  }
}

// Local wrapper to replicate the visual style of DoctorDashboardTopHeader
// but allowing us to swap the inner content if needed.
class _TaHeaderWrapper extends StatelessWidget {
  const _TaHeaderWrapper();

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16, // Add a bit of top padding since we don't have the fixed height centering anymore
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: isLight
            ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reuse the internal content widget (Avatar + Name)
          // Ideally, this widget accepts a name parameter.
          // If not, creates a TaDashboardHeader similar to DoctorDashboardHeader.
          const DoctorDashboardHeader(),
          SizedBox(height: 16), // Bottom padding before the border radius cuts off
        ],
      ),
    );
  }
}