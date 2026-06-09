import 'package:bnu_lms_app/features/tasks/data/models/assignment_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/assignment_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class CourseAssignmentsTab extends StatefulWidget {
  final int courseId;
  const CourseAssignmentsTab({required this.courseId, super.key});

  @override
  State<CourseAssignmentsTab> createState() => _CourseAssignmentsTabState();
}

class _CourseAssignmentsTabState extends State<CourseAssignmentsTab> {
  final AssignmentRepository _assignmentRepository = AssignmentRepository();
  List<Assignment> _assignments = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  Future<void> _fetchAssignments() async {
    try {
      final assignments = await _assignmentRepository.getAssignments(widget.courseId);
      if (mounted) {
        setState(() {
          _assignments = assignments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorsManager.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: ColorsManager.white, size: 16),
                      const SizedBox(width: 4),
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
          const SizedBox(height: 20),

          ..._assignments.map((assignment) => _buildAssignmentCard(
                context,
                assignment.title,
                'Due: ${assignment.dueDate.toString().split(' ')[0]}',
                assignment.isSubmitted ? 'SUBMITTED' : 'PENDING',
                assignment.isSubmitted ? ColorsManager.green : ColorsManager.yellow,
                0, // TODO: Fetch submissions count
                100, // TODO: Fetch total student count
              )),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, String title, String dueDate, String status, Color statusColor, int submitted, int total) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    double progress = total > 0 ? submitted / total : 0.0;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to assignment details
        debugPrint("Assignment $title clicked");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isLight
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 12, color: ColorsManager.grayMedium),
                          const SizedBox(width: 4),
                          Text(dueDate, style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: AppLightTextStyles.labelSmall.copyWith(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SUBMISSIONS', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('$submitted', style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                        Text('/$total', style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: ColorsManager.grayMedium),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
