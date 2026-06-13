import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../assignments/presentation/screens/create_assignment_screen.dart';
import '../../../../../../assignments/presentation/screens/assignment_submissions_screen.dart';
import '../../../../../../assignments/presentation/manager/instructor/assignments_cubit.dart';
import '../../../../../../assignments/presentation/manager/instructor/assignments_state.dart';
import '../../../../../../assignments/domain/entities/assignment_entity.dart';

class TaCourseAssignmentsTab extends StatelessWidget {
  final int courseId;
  const TaCourseAssignmentsTab({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return BlocBuilder<AssignmentsCubit, AssignmentsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Create Assignment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AssignmentsCubit>(),
                            child: CreateAssignmentScreen(courseId: courseId),
                          ),
                        ),
                      ).then((_) => context.read<AssignmentsCubit>().getAssignments(courseId));
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Create Assignment',
                      style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cyan,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Course Assignments',
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: state.maybeWhen(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    success: (assignments) => assignments.isEmpty
                        ? Center(
                            child: Text(
                              'No assignments yet.',
                              style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: assignments.length,
                            itemBuilder: (context, index) {
                              return _buildTaAssignmentCard(context, assignments[index]);
                            },
                          ),
                    error: (message) => Center(
                      child: Text(
                        message,
                        style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium)
                            .copyWith(color: ColorsManager.red),
                      ),
                    ),
                    orElse: () => Center(
                      child: Text(
                        'Initializing...',
                        style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaAssignmentCard(BuildContext context, AssignmentEntity assignment) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : ColorsManager.blue.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                assignment.title, 
                style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium
              ),
              Icon(Icons.more_vert, color: ColorsManager.grayMedium, size: 20),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due: ${assignment.dueDate.day} ${_getMonth(assignment.dueDate.month)}', 
                style: isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall
              ),
              Text(
                'Submitted: --/--', 
                style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.blue)
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignmentSubmissionsScreen(assignmentId: assignment.id),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorsManager.blue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                'View Submissions', 
                style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.blue)
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
