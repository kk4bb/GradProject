import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class TaCourseAssignmentsTab extends StatelessWidget {
  const TaCourseAssignmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return ListView(
      padding: EdgeInsets.all(20.0),
      children: [
        _buildSectionHeader(isLight, 'Active Tasks'),
        SizedBox(height: 16.0),

        // Card 1: Needs Grading
        _TaAssignmentCard(
          title: 'Assignment 4: Binary Search Trees',
          dueDate: 'Oct 12, 11:59 PM',
          submissionCount: '38/52 Submitted',
          pendingGrading: '12 pending to grade',
          isLight: isLight,
          status: _AssignmentStatus.needsGrading,
        ),

        SizedBox(height: 16.0),

        // Card 2: In Progress
        _TaAssignmentCard(
          title: 'Midterm Project: Library System',
          dueDate: 'Oct 20, 11:59 PM',
          submissionCount: '5/52 Submitted',
          pendingGrading: 'Awaiting more submissions',
          isLight: isLight,
          status: _AssignmentStatus.inProgress,
        ),

        SizedBox(height: 32.0),
        _buildSectionHeader(isLight, 'Past Assignments'),
        SizedBox(height: 16.0),

        // Card 3: Completed
        _TaAssignmentCard(
          title: 'Lab 3: Linked Lists',
          dueDate: 'Oct 01, 11:59 PM',
          submissionCount: '51/52 Graded',
          pendingGrading: 'Grading Complete',
          isLight: isLight,
          status: _AssignmentStatus.completed,
        ),

        SizedBox(height: 80.0),
      ],
    );
  }

  Widget _buildSectionHeader(bool isLight, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Icon(Icons.filter_list, size: 20.0, color: ColorsManager.grayMedium),
      ],
    );
  }
}

enum _AssignmentStatus { needsGrading, inProgress, completed }

class _TaAssignmentCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final String submissionCount;
  final String pendingGrading;
  final bool isLight;
  final _AssignmentStatus status;

  const _TaAssignmentCard({
    required this.title,
    required this.dueDate,
    required this.submissionCount,
    required this.pendingGrading,
    required this.isLight,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final cyan = const Color(0xFF2FBAD7); // TA Theme Color
    final shadowColor = Colors.black.withValues(alpha: 0.05);

    // Status Logic
    Color statusColor;
    String statusText;

    switch (status) {
      case _AssignmentStatus.needsGrading:
        statusColor = Colors.orange;
        statusText = 'NEEDS GRADING';
        break;
      case _AssignmentStatus.inProgress:
        statusColor = ColorsManager.lightBlueAccent;
        statusText = 'IN PROGRESS';
        break;
      case _AssignmentStatus.completed:
        statusColor = ColorsManager.green;
        statusText = 'COMPLETED';
        break;
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight
            ? [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tag & Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.more_horiz, color: ColorsManager.grayMedium, size: 20.0),
            ],
          ),
          SizedBox(height: 12.0),

          // Title
          Text(
            title,
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.0),

          // Details Row
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14.0, color: ColorsManager.grayMedium),
              SizedBox(width: 6.0),
              Text(
                dueDate,
                style: TextStyle(fontSize: 12.0, color: ColorsManager.grayMedium),
              ),
              SizedBox(width: 16.0),
              Icon(Icons.people_outline, size: 14.0, color: ColorsManager.grayMedium),
              SizedBox(width: 6.0),
              Text(
                submissionCount,
                style: TextStyle(fontSize: 12.0, color: ColorsManager.grayMedium),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          Divider(color: ColorsManager.grayMedium.withValues(alpha: 0.1)),
          SizedBox(height: 12.0),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pendingGrading,
                style: TextStyle(
                  fontSize: 12.0,
                  color: ColorsManager.grayMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Action Button
              if (status != _AssignmentStatus.completed)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.taAssignmentGrades);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cyan, // TA Cyan
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  child: Text(
                    'Grade Now',
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorsManager.grayMedium,
                    side: BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}