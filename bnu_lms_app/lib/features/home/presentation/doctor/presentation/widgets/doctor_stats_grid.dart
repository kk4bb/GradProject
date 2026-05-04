import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../shared/resources/app_sizes.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import 'dashboard_stat_card.dart';

class DoctorStatsGrid extends StatelessWidget {
  final int courseCount;
  const DoctorStatsGrid({required this.courseCount, super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    // 2. Define the core brand colors for the icons
    const blue = Color(0xFF1E61ED);
    const green = Color(0xFF0F9D58);
    const orange = Color(0xFFF25C05);
    const purple = Color(0xFF8B5CF6);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.horizontalPadding,
        vertical: 16.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardStatCard(
                icon: Icons.menu_book_rounded,
                iconColor: blue,
                // Uses pastel in light mode, and a 15% opacity tint in dark mode
                iconBackgroundColor: isLight ? const Color(0xFFEEF3FF) : blue.withValues(alpha: 0.15),
                value: courseCount.toString(),
                title: 'Active Courses',
              ),
              SizedBox(width: 16.0),
              DashboardStatCard(
                icon: Icons.people_alt_rounded,
                iconColor: green,
                iconBackgroundColor: isLight ? const Color(0xFFE6F4EA) : green.withValues(alpha: 0.15),
                value: '--', // Could fetch total students
                title: 'Total Students',
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardStatCard(
                icon: Icons.assignment_late_outlined,
                iconColor: orange,
                iconBackgroundColor: isLight ? const Color(0xFFFFF0E6) : orange.withValues(alpha: 0.15),
                value: '0', // Could fetch pending assignments to grade
                title: 'Pending Tasks',
              ),
              SizedBox(width: 16.0),
              DashboardStatCard(
                icon: Icons.calendar_today_rounded,
                iconColor: purple,
                iconBackgroundColor: isLight ? const Color(0xFFF3E8FF) : purple.withValues(alpha: 0.15),
                value: '0', // Could fetch today's lectures
                title: "Today's Lectures",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
