import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_attempt_entity.dart';
import '../cubit/quiz_grading_cubit.dart';

class StudentAnswersReviewScreen extends StatefulWidget {
  final QuizEntity quiz;
  final QuizAttemptEntity attempt;

  const StudentAnswersReviewScreen({
    super.key,
    required this.quiz,
    required this.attempt,
  });

  @override
  State<StudentAnswersReviewScreen> createState() => _StudentAnswersReviewScreenState();
}

class _StudentAnswersReviewScreenState extends State<StudentAnswersReviewScreen> {
  final TextEditingController _scoreController = TextEditingController();

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);
    final isPending = widget.attempt.status.toLowerCase() == 'pending review';

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        title: Text('Review Attempt', style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
        backgroundColor: surfaceColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isLight ? ColorsManager.black : ColorsManager.white),
      ),
      body: BlocConsumer<QuizGradingCubit, QuizGradingState>(
        listener: (context, state) {
          if (state is QuizGradingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            Navigator.pop(context, true); // Return true to refresh list
          } else if (state is QuizGradingError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: ColorsManager.red));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                          border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Name: ${widget.attempt.studentName ?? widget.attempt.studentId}',
                              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Auto-graded Score:', style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium),
                                Text('${widget.attempt.score} / ${widget.quiz.totalMarks > 0 ? widget.quiz.totalMarks.toInt() : widget.quiz.questionCount * 10}', style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status:', style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium),
                                Text(
                                  widget.attempt.status,
                                  style: TextStyle(
                                    color: isPending ? Colors.orange : ColorsManager.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text('Essay Question Answer', style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          widget.attempt.essayAnswer?.isNotEmpty == true ? widget.attempt.essayAnswer! : 'No essay answer provided.',
                          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isPending)
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _scoreController,
                          keyboardType: TextInputType.number,
                          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Enter Score',
                            hintStyle: TextStyle(color: ColorsManager.grayMedium),
                            filled: true,
                            fillColor: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: state is QuizGradingLoading ? null : () {
                          final score = double.tryParse(_scoreController.text);
                          if (score != null) {
                            context.read<QuizGradingCubit>().gradeEssay(widget.quiz.id, widget.attempt.id, score);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid number'), backgroundColor: Colors.red));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26C6DA),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: state is QuizGradingLoading
                            ? SizedBox(width: 20, height: 20, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Submit Grade', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
