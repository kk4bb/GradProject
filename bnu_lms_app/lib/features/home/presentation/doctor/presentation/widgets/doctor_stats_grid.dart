import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import 'dashboard_stat_card.dart';

class DoctorStatsGrid extends StatefulWidget {
  const DoctorStatsGrid({super.key});

  @override
  State<DoctorStatsGrid> createState() => _DoctorStatsGridState();
}

class _DoctorStatsGridState extends State<DoctorStatsGrid> {
  final CourseRepository _courseRepository = CourseRepository();
  int _activeCoursesCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final courses = await _courseRepository.getAssignedCourses();
      if (mounted) {
        setState(() {
          _activeCoursesCount = courses.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    const blue = Color(0xFF1E61ED);
    const green = Color(0xFF0F9D58);
    const orange = Color(0xFFF25C05);
    const purple = Color(0xFF8B5CF6);

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardStatCard(
                icon: Icons.menu_book_rounded,
                iconColor: blue,
                iconBackgroundColor: isLight ? const Color(0xFFEEF3FF) : blue.withValues(alpha: 0.15),
                value: _activeCoursesCount.toString(),
                title: 'Active Courses',
              ),
              const SizedBox(width: 16),
              DashboardStatCard(
                icon: Icons.people_alt_rounded,
                iconColor: green,
                iconBackgroundColor: isLight ? const Color(0xFFE6F4EA) : green.withValues(alpha: 0.15),
                value: '245', // TODO: Fetch from API
                title: 'Total Students',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardStatCard(
                icon: Icons.assignment_late_outlined,
                iconColor: orange,
                iconBackgroundColor: isLight ? const Color(0xFFFFF0E6) : orange.withValues(alpha: 0.15),
                value: '12', // TODO: Fetch from API
                title: 'Pending Tasks',
              ),
              const SizedBox(width: 16),
              DashboardStatCard(
                icon: Icons.calendar_today_rounded,
                iconColor: purple,
                iconBackgroundColor: isLight ? const Color(0xFFF3E8FF) : purple.withValues(alpha: 0.15),
                value: '3', // TODO: Fetch from API
                title: "Today's Lectures",
              ),
            ],
          ),
        ],
      ),
    );
  }
}