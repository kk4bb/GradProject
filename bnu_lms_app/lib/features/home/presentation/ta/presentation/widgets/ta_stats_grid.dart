import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../doctor/presentation/widgets/dashboard_stat_card.dart';

class TaStatsGrid extends StatelessWidget {
  const TaStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    // TA Specific Colors (Cyan dominant)
    const cyan = Color(0xFF2FBAD7);
    const orange = Color(0xFFF25C05);
    const purple = Color(0xFF8B5CF6);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(), // Adds a nice bounce effect on iOS/Android 12+
      padding: REdgeInsets.symmetric(horizontal: 24), // Padding is now inside the scroll
      child: Row(
        children: [
          DashboardStatCard(
            icon: Icons.science_outlined,
            iconColor: cyan,
            iconBackgroundColor: isLight ? cyan.withValues(alpha: 0.1) : cyan.withValues(alpha: 0.15),
            value: '4',
            title: 'Labs This Week',
          ),
          SizedBox(width: 16.w),
          DashboardStatCard(
            icon: Icons.star_border_rounded,
            iconColor: orange,
            iconBackgroundColor: isLight ? orange.withValues(alpha: 0.1) : orange.withValues(alpha: 0.15),
            value: '12',
            title: 'Pending Grading',
          ),
          SizedBox(width: 16.w),
          DashboardStatCard(
            icon: Icons.forum_outlined,
            iconColor: purple,
            iconBackgroundColor: isLight ? purple.withValues(alpha: 0.1) : purple.withValues(alpha: 0.15),
            value: '8',
            title: 'Forum Questions',
          ),
        ],
      ),
    );
  }
}