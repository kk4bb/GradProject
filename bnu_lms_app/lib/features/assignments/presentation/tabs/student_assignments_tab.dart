import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/di/injection.dart';
import '../manager/student/student_assignments_cubit.dart';
import '../manager/student/student_assignments_state.dart';
import '../screens/assignment_details_screen.dart';
import '../screens/assignment_result_screen.dart';
import '../../domain/entities/assignment_entity.dart';

class StudentAssignmentsTab extends StatelessWidget {
  final int courseId;

  const StudentAssignmentsTab({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return BlocProvider(
      create: (context) => getIt<StudentAssignmentsCubit>()..getAssignments(courseId),
      child: BlocBuilder<StudentAssignmentsCubit, StudentAssignmentsState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (assignments) => RefreshIndicator(
              onRefresh: () => context.read<StudentAssignmentsCubit>().fetchAssignments(courseId),
              child: assignments.isEmpty 
                ? ListView( 
                    children: [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          "No assignments yet", 
                          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium
                        )
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      return _buildStudentAssignmentCard(context, assignments[index]);
                    },
                  ),
            ),
            error: (message) => Center(
              child: Text(
                message, 
                style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.red)
              )
            ),
            orElse: () => Center(
              child: Text(
                "Initializing...", 
                style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium
              )
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentAssignmentCard(BuildContext context, AssignmentEntity assignment) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    bool isGraded = assignment.status.toLowerCase() == 'graded' || assignment.status.toLowerCase() == 'completed';

    return GestureDetector(
      onTap: () {
        if (isGraded) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AssignmentResultScreen(assignment: assignment)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AssignmentDetailsScreen(assignment: assignment)),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : ColorsManager.blue.withValues(alpha: 0.1)),
          boxShadow: isLight 
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ] 
            : [],
        ),
        child: Row(
          children: [
            _StatusIndicator(status: assignment.status),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title, 
                    style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}/${assignment.dueDate.year}',
                    style: isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: ColorsManager.grayMedium),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    // final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'upcoming':
        color = ColorsManager.yellow;
        break;
      case 'submitted':
        color = ColorsManager.blue;
        break;
      case 'graded':
      case 'completed':
        color = ColorsManager.green;
        break;
      default:
        color = ColorsManager.grayMedium;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status.toLowerCase() == 'graded' ? Icons.check_circle : Icons.assignment_outlined,
        color: color,
        size: 24,
      ),
    );
  }
}
