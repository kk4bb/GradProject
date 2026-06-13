import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_grading_cubit.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class QuizPreviewStep extends StatelessWidget {
  final VoidCallback onBack;

  const QuizPreviewStep({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);
    final inputFillColor = isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24);

    final cubit = context.watch<QuizGradingCubit>();
    final title = cubit.creationTitle.isNotEmpty ? cubit.creationTitle : 'Untitled Quiz';
    final duration = cubit.creationDuration.isNotEmpty ? cubit.creationDuration : '0';
    final description = cubit.creationDescription.isNotEmpty ? cubit.creationDescription : 'Provide instructions for the students...';
    final questions = cubit.creationQuestions;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isLight
                  ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorsManager.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Advanced Software Engineering',
                        style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(
                          color: ColorsManager.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: ColorsManager.grayMedium),
                        SizedBox(width: 4),
                        Text(
                          '$duration MINS',
                          style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Stats Grid
          Row(
            children: [
              Expanded(child: _buildStatCard(isLight, surfaceColor, 'Total Questions', '${questions.length}', Icons.list_alt)),
              SizedBox(width: 16),
              Expanded(child: _buildStatCard(isLight, surfaceColor, 'Total Points', '${questions.fold(0, (sum, q) => sum + (q['points'] as int? ?? 1))}', Icons.stars_outlined)),
            ],
          ),

          SizedBox(height: 32),
          Text(
            'Questions Preview',
            style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
          ),
          SizedBox(height: 16),

          // Question List
          if (questions.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No questions added yet.', style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium)),
              ),
            )
          else
            ...questions.asMap().entries.map((entry) {
              final idx = entry.key;
              final q = entry.value;
              final options = (q['options'] as List<Map<String, dynamic>>? ?? []);
              int correctIndex = options.indexWhere((o) => o['isCorrect'] == true);
              
              return _buildQuestionPreviewItem(
                isLight,
                surfaceColor,
                inputFillColor,
                idx + 1,
                q['text'] ?? '',
                q['points'] ?? 1,
                options.map((e) => e['text'].toString()).toList(),
                correctIndex >= 0 ? correctIndex : 0,
              );
            }),

          SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isLight ? ColorsManager.grayMedium : ColorsManager.grayDark),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Edit Details',
                  style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              BlocConsumer<QuizGradingCubit, QuizGradingState>(
                listener: (context, state) {
                  if (state is QuizGradingSuccess && state.message.contains('published')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: const Color(0xFF26C6DA)),
                    );
                    Navigator.pop(context);
                  } else if (state is QuizGradingError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: ColorsManager.red),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is QuizGradingLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : () {
                      context.read<QuizGradingCubit>().publishQuiz();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26C6DA),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: isLoading 
                      ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ColorsManager.white))
                      : Row(
                          children: [
                            Text(
                              'Publish Quiz',
                              style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.rocket_launch, color: ColorsManager.white, size: 16),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(bool isLight, Color surfaceColor, String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF26C6DA), size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
              Text(label, style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPreviewItem(bool isLight, Color surfaceColor, Color inputFillColor, int number, String question, int points, List<String> options, int correctIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.grayMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $number',
                style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: inputFillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$points Points',
                  style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(question, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
          SizedBox(height: 16),
          ...options.asMap().entries.map((entry) {
            bool isCorrect = entry.key == correctIndex;
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCorrect ? const Color(0xFF26C6DA).withValues(alpha: 0.1) : inputFillColor,
                borderRadius: BorderRadius.circular(8),
                border: isCorrect ? Border.all(color: const Color(0xFF26C6DA)) : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isCorrect ? const Color(0xFF26C6DA) : ColorsManager.grayMedium,
                    size: 18,
                  ),
                  SizedBox(width: 12),
                  Text(
                    entry.value,
                    style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(
                      fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                      color: isCorrect ? (isLight ? ColorsManager.black : ColorsManager.white) : ColorsManager.grayMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
