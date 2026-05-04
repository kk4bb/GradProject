import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/network/repositories/quiz_repository.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/routes_manager/routes.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../data/models/quiz_model.dart';

class QuizQuestionsScreen extends StatefulWidget {
  final QuizTake quiz;

  const QuizQuestionsScreen({required this.quiz, super.key});

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  final QuizRepository _quizRepository = QuizRepository();
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // QuestionId -> OptionId
  bool _isSubmitting = false;

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitQuiz() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final List<Map<String, int>> formattedAnswers = _selectedAnswers.entries
          .map((e) => {
                'questionId': e.key,
                'selectedOptionId': e.value,
              })
          .toList();

      debugPrint('Submitting quiz ${widget.quiz.id} with answers: $formattedAnswers');

      final result = await _quizRepository.submitQuiz(widget.quiz.id, formattedAnswers);
      
      debugPrint('Quiz submitted successfully. Result: ${result.score}%');

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.quizResults,
          arguments: {
            'quizTitle': widget.quiz.title,
            'result': result,
          },
        );
      }
    } catch (e) {
      debugPrint('Quiz submission failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submission failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final question = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
          style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: isLight ? Colors.grey[200] : ColorsManager.darkSurface,
              valueColor: const AlwaysStoppedAnimation<Color>(ColorsManager.blue),
            ),
            const SizedBox(height: 32),

            // Question Text
            Text(
              question.text,
              style: isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = _selectedAnswers[question.id] == option.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: _isSubmitting ? null : () {
                        setState(() {
                          _selectedAnswers[question.id] = option.id;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorsManager.blue.withValues(alpha: 0.1)
                              : (isLight ? ColorsManager.white : ColorsManager.darkSurface),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? ColorsManager.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? ColorsManager.blue : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Center(
                                      child: CircleAvatar(
                                        radius: 6,
                                        backgroundColor: ColorsManager.blue,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option.text,
                                style: isLight
                                    ? AppLightTextStyles.bodyMedium
                                    : AppDarkTextStyles.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isSubmitting)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : _previousQuestion,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: ColorsManager.blue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                    ),
                  Expanded(
                    child: CustomElevatedButton(
                      label: _currentQuestionIndex == widget.quiz.questions.length - 1
                          ? 'Submit Quiz'
                          : 'Next Question',
                      onTap: _isSubmitting 
                          ? null 
                          : (_currentQuestionIndex == widget.quiz.questions.length - 1
                              ? _submitQuiz
                              : _nextQuestion),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
