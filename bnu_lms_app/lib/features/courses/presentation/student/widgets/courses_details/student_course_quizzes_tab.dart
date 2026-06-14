import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_list_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/widgets/student_quiz_card.dart';
import 'package:provider/provider.dart';

class StudentCourseQuizzesTab extends StatefulWidget {
  final int courseId;
  const StudentCourseQuizzesTab({super.key, required this.courseId});

  @override
  State<StudentCourseQuizzesTab> createState() => _StudentCourseQuizzesTabState();
}

class _StudentCourseQuizzesTabState extends State<StudentCourseQuizzesTab> {
  @override
  void initState() {
    super.initState();
    context.read<QuizListCubit>().loadQuizzes(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return BlocBuilder<QuizListCubit, QuizListState>(
      builder: (context, state) {
        if (state is QuizListLoading) {
          return const Center(child: CircularProgressIndicator(color: ColorsManager.blue));
        } else if (state is QuizListError) {
          return Center(child: Text(state.message, style: const TextStyle(color: ColorsManager.red)));
        } else if (state is QuizListLoaded) {
          if (state.quizzes.isEmpty) {
            return Center(
              child: Text('No quizzes available.', style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<QuizListCubit>().loadQuizzes(widget.courseId);
            },
            child: ListView.separated(
              padding: EdgeInsets.all(20),
              itemCount: state.quizzes.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final quiz = state.quizzes[index];
                
                String status;
                String actionText;
                
                if (quiz.areGradesPublished) {
                  status = 'GRADED';
                  actionText = 'View Results >';
                } else if (quiz.hasAttempted) {
                  status = 'SUBMITTED';
                  actionText = 'View Attempt >';
                } else {
                  status = 'READY';
                  actionText = 'Take Quiz >';
                }

                return StudentQuizCard(
                  quiz: quiz,
                  title: quiz.title,
                  courseTitle: quiz.description,
                  status: status,
                  date: DateFormat('dd/MM/yyyy hh:mm a').format(quiz.startDate.toLocal()),
                  duration: '${quiz.durationMinutes} Mins',
                  questionsCount: '${quiz.questionCount} Questions',
                  actionText: actionText,
                  isInstructor: false,
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
