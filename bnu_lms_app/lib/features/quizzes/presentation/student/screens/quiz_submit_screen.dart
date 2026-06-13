import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_taking_cubit.dart';

import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';

class QuizSubmitScreen extends StatelessWidget {
  const QuizSubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);
    
    // Mock data
    final int totalQuestions = 10;
    final int answered = 9;
    final int missing = totalQuestions - answered;

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(Icons.assignment_turned_in_outlined, size: 80, color: const Color(0xFF26C6DA)),
              SizedBox(height: 24),
              Text(
                'Ready to submit?',
                style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Review your progress before final submission.',
                style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Summary Grid
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(isLight, surfaceColor, 'Answered', answered.toString(), const Color(0xFF26C6DA))),
                  SizedBox(width: 16),
                  Expanded(child: _buildSummaryCard(isLight, surfaceColor, 'Missing', missing.toString(), missing > 0 ? ColorsManager.red : ColorsManager.grayMedium)),
                ],
              ),

              SizedBox(height: 24),

              if (missing > 0)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsManager.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorsManager.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: ColorsManager.red, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You have $missing unanswered question(s). Are you sure you want to submit?',
                          style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Actions
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF26C6DA)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Continue Review',
                    style: TextStyle(
                      color: const Color(0xFF26C6DA),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<QuizTakingCubit, QuizTakingState>(
                  listener: (context, state) {
                    if (state is QuizTakingSubmitted) {
                      Navigator.pushReplacementNamed(context, Routes.quizResults);
                    } else if (state is QuizTakingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: ColorsManager.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is QuizTakingSubmitting;

                    return ElevatedButton(
                      onPressed: isLoading ? null : () {
                        // Mock submission data
                        context.read<QuizTakingCubit>().submitQuiz(1, {'answers': {}});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLight ? ColorsManager.darkBlue : ColorsManager.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        disabledBackgroundColor: isLight ? ColorsManager.darkBlue.withValues(alpha: 0.5) : ColorsManager.white.withValues(alpha: 0.5),
                      ),
                      child: isLoading 
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: isLight ? ColorsManager.white : ColorsManager.darkBlue,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Submit Quiz',
                            style: TextStyle(
                              color: isLight ? ColorsManager.white : ColorsManager.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(bool isLight, Color surfaceColor, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
        border: Border.all(color: isLight ? Colors.transparent : ColorsManager.grayMedium.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium),
          ),
        ],
      ),
    );
  }
}
