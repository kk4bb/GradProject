import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/di/injection.dart';
import '../manager/instructor/grading_cubit.dart';
import '../manager/instructor/grading_state.dart';
import '../../domain/entities/submission_entity.dart';
import 'grading_screen.dart';

class AssignmentSubmissionsScreen extends StatelessWidget {
  final int assignmentId;

  const AssignmentSubmissionsScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return BlocProvider(
      create: (context) => getIt<GradingCubit>()..getSubmissions(assignmentId),
      child: Scaffold(
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        appBar: AppBar(
          title: Text(
            'Submissions', 
            style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: isLight ? ColorsManager.black : ColorsManager.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<GradingCubit, GradingState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              submissionsLoaded: (submissions) {
                if (submissions.isEmpty) {
                  return Center(
                    child: Text(
                      'No submissions yet.',
                      style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: submissions.length,
                  itemBuilder: (context, index) {
                    return _buildSubmissionCard(context, submissions[index]);
                  },
                );
              },
              error: (message) => Center(
                child: Text(
                  message,
                  style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.red),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(BuildContext context, SubmissionEntity submission) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : ColorsManager.blue.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: ColorsManager.blue.withValues(alpha: 0.1),
          child: Text(
            submission.studentName.isNotEmpty ? submission.studentName[0].toUpperCase() : 'S',
            style: const TextStyle(color: ColorsManager.blue, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          submission.studentName,
          style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
        ),
        subtitle: Text(
          'ID: ${submission.studentId}',
          style: isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              submission.grade != null ? '${submission.grade!.toInt()}' : 'N/A',
              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(
                color: submission.grade != null ? ColorsManager.green : ColorsManager.grayMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Grade',
              style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
            ),
          ],
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GradingScreen(
                submissionId: submission.id,
                assignmentId: submission.assignmentId,
                studentName: submission.studentName,
                submissionDate: submission.submissionDate,
                initialGrade: submission.grade,
                initialFeedback: submission.feedback,
              ),
            ),
          );

          if (result == true && context.mounted) {
            context.read<GradingCubit>().getSubmissions(assignmentId);
          }
        },
      ),
    );
  }
}
