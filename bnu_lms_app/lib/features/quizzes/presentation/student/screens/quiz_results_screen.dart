import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/di/injection.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../domain/entities/quiz_entity.dart';
import '../../cubit/quiz_results_cubit.dart';


class QuizResultsScreen extends StatelessWidget {
  final QuizEntity quiz;

  const QuizResultsScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return BlocProvider(
      create: (context) => getIt<QuizResultsCubit>()..fetchResults(quiz.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz Results', style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
          backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
          iconTheme: IconThemeData(color: isLight ? ColorsManager.black : ColorsManager.white),
        ),
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        body: BlocBuilder<QuizResultsCubit, QuizResultsState>(
          builder: (context, state) {
            if (state is QuizResultsLoading || state is QuizResultsInitial) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF26C6DA)));
            } else if (state is QuizResultsError) {
              final msg = state.message.toLowerCase();
              if (msg.contains('not published') || msg.contains('pending') || msg.contains('403')) {
                return _buildPendingUi(isLight, context);
              }
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    state.message.replaceAll('Exception: ', ''),
                    style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: ColorsManager.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (state is QuizResultsLoaded) {
              final attempt = state.attempt;
              // Allow viewing if explicitly published OR if status already indicates it's graded/completed
              final bool isGradedOrCompleted = attempt.status == 'Graded' || attempt.status == 'Completed';
              
              if (attempt.status == 'Pending Review' || (!quiz.areGradesPublished && !isGradedOrCompleted)) {
                return _buildPendingUi(isLight, context);
              }
              
              return Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isLight ? ColorsManager.white : const Color(0xFF131F24),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            attempt.score >= 50 ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                            size: 80,
                            color: attempt.score >= 50 ? Colors.amber : ColorsManager.grayMedium,
                          ),
                          SizedBox(height: 24),
                          Text(
                            attempt.title,
                            style: isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Final Score',
                            style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '${attempt.score.toStringAsFixed(1)} / ${quiz.totalMarks > 0 ? quiz.totalMarks.toInt() : quiz.questionCount * 10}',
                            style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(
                              color: const Color(0xFF26C6DA),
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                          ),
                          SizedBox(height: 24),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: ColorsManager.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              attempt.status,
                              style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(
                                color: ColorsManager.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26C6DA),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Back to Dashboard',
                          style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildPendingUi(bool isLight, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.white : const Color(0xFF131F24),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF26C6DA).withValues(alpha: 0.3)),
            boxShadow: isLight
                ? [BoxShadow(color: const Color(0xFF26C6DA).withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.hourglass_empty_rounded,
                  size: 64,
                  color: const Color(0xFF26C6DA),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Submission Successful!',
                style: (isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall).copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Your quiz was submitted successfully! The instructor is currently reviewing the responses. Grades will be published here once finalized.',
                style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(
                  color: ColorsManager.grayMedium,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26C6DA),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Back to Dashboard',
                    style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
