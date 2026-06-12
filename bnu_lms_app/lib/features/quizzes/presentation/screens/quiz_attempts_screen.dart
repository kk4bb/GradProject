import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/quiz_entity.dart';
import '../cubit/quiz_attempts_cubit.dart';
import '../cubit/quiz_grading_cubit.dart';
import 'student_answers_review_screen.dart';

class QuizAttemptsScreen extends StatelessWidget {
  final QuizEntity quiz;

  const QuizAttemptsScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<QuizAttemptsCubit>()..fetchAttempts(quiz.id)),
        BlocProvider(create: (_) => getIt<QuizGradingCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz Attempts', style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
          backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
          iconTheme: IconThemeData(color: isLight ? ColorsManager.black : ColorsManager.white),
        ),
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        body: BlocConsumer<QuizGradingCubit, QuizGradingState>(
          listener: (context, gradingState) {
            if (gradingState is QuizGradingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(gradingState.message), backgroundColor: Colors.green));
              context.read<QuizAttemptsCubit>().fetchAttempts(quiz.id); // Refresh after grading
            } else if (gradingState is QuizGradingError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(gradingState.message), backgroundColor: Colors.red));
            }
          },
          builder: (context, gradingState) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: isLight ? ColorsManager.white : const Color(0xFF131F24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          quiz.title,
                          style: isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: gradingState is QuizGradingLoading ? null : () {
                          context.read<QuizGradingCubit>().publishGrades(quiz.id);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26C6DA)),
                        child: gradingState is QuizGradingLoading 
                            ? SizedBox(width: 16, height: 16, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Publish Grades', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<QuizAttemptsCubit, QuizAttemptsState>(
                    builder: (context, state) {
                      if (state is QuizAttemptsLoading || state is QuizAttemptsInitial) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF26C6DA)));
                      } else if (state is QuizAttemptsError) {
                        return Center(child: Text(state.message, style: TextStyle(color: ColorsManager.red)));
                      } else if (state is QuizAttemptsLoaded) {
                        if (state.attempts.isEmpty) {
                          return Center(child: Text('No attempts found.', style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium));
                        }
                        return ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: state.attempts.length,
                          itemBuilder: (context, index) {
                            final attempt = state.attempts[index];
                            final isPending = attempt.status.toLowerCase() == 'pending review';
                              return GestureDetector(
                                onTap: () async {
                                  final shouldRefresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<QuizGradingCubit>(),
                                        child: StudentAnswersReviewScreen(quiz: quiz, attempt: attempt),
                                      ),
                                    ),
                                  );
                                  if (shouldRefresh == true && context.mounted) {
                                    context.read<QuizAttemptsCubit>().fetchAttempts(quiz.id);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isLight ? ColorsManager.white : const Color(0xFF1A2A30),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
                                    boxShadow: isLight
                                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(attempt.studentName ?? attempt.studentId, style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          Text('Score: ${attempt.score} / ${quiz.totalMarks > 0 ? quiz.totalMarks.toInt() : quiz.questionCount * 10}', style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium)),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isPending ? Colors.orange.withValues(alpha: 0.1) : ColorsManager.green.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          attempt.status ,
                                          style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(
                                            color: isPending ? Colors.orange : ColorsManager.green,
                                            fontWeight: FontWeight.bold,
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
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

    // This dialog is no longer used, as grading happens in the StudentAnswersReviewScreen.
    // Keeping method stub to prevent any build errors if referenced elsewhere.
  }


