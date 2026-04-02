import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';

// Import the separated widgets
import '../widgets/forum_task_card.dart';
import '../widgets/grading_card.dart';

import '../widgets/lab_session_card.dart';
import '../widgets/resources_section.dart';
import '../widgets/ta_tasks_header.dart';


class TaTasksTab extends StatelessWidget {
  const TaTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            const TaTasksHeader(),
            SizedBox(height: 24.h),

            // 1. Submissions to Grade
            _buildSectionHeader(context, 'Submissions to Grade', badgeCount: '8 Pending'),
            SizedBox(height: 16.h),
            const GradingCard(),
            SizedBox(height: 24.h),

            // 2. Labs Today
            _buildSectionHeader(context, 'Labs Today', badgeCount: null),
            SizedBox(height: 16.h),
            const LabSessionCard(),
            SizedBox(height: 24.h),

            // 3. Forum Unanswered
            _buildSectionHeader(context, 'Forum Unanswered', badgeCount: null),
            SizedBox(height: 16.h),
            const ForumTaskCard(),
            SizedBox(height: 24.h),

            // 4. Resources
            _buildSectionHeader(context, 'Resources', badgeCount: null),
            SizedBox(height: 16.h),
            const ResourcesSection(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {String? badgeCount}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: (isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall)
              .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        if (badgeCount != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: cyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              badgeCount,
              style: TextStyle(color: cyan, fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}