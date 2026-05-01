import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/network/repositories/assignment_repository.dart';
import '../../../../../../tasks/data/models/assignment_model.dart';

class CourseAssignmentsTab extends StatefulWidget {
  final int courseId;
  const CourseAssignmentsTab({required this.courseId, super.key});

  @override
  State<CourseAssignmentsTab> createState() => _CourseAssignmentsTabState();
}

class _CourseAssignmentsTabState extends State<CourseAssignmentsTab> {
  final AssignmentRepository _assignmentRepository = AssignmentRepository();
  late Future<List<Assignment>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    _assignmentsFuture = _assignmentRepository.getAssignments(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return FutureBuilder<List<Assignment>>(
      future: _assignmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final assignments = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Assignments',
                    style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement Create Assignment flow
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: ColorsManager.blue,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: ColorsManager.white, size: 16.0),
                          SizedBox(width: 4.0),
                          Text(
                            'Create',
                            style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              if (assignments.isEmpty)
                const Center(child: Text('No assignments created yet.'))
              else
                ...assignments.map((assignment) => _buildAssignmentCard(
                  context,
                  assignment.title,
                  'Due: ${DateFormat('MMM dd, yyyy • hh:mm a').format(assignment.dueDate)}',
                  DateTime.now().isBefore(assignment.dueDate) ? 'ACTIVE' : 'EXPIRED',
                  DateTime.now().isBefore(assignment.dueDate) ? ColorsManager.blue : ColorsManager.red,
                  0, // Placeholder for submitted count
                  0, // Placeholder for total students
                )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssignmentCard(BuildContext context, String title, String dueDate, String status, Color statusColor, int submitted, int total) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    double progress = total > 0 ? submitted / total : 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8.0, offset: const Offset(0, 2))]
            : [],
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to assignment submissions view
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12.0, color: ColorsManager.grayMedium),
                          SizedBox(width: 4.0),
                          Text(dueDate, style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 11.0)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    status,
                    style: AppLightTextStyles.labelSmall.copyWith(color: statusColor, fontSize: 10.0, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            if (total > 0) ...[
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SUBMISSIONS', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.0)),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text('$submitted', style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                          Text('/$total', style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16.0, color: ColorsManager.grayMedium),
                ],
              ),
              SizedBox(height: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 4.0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}