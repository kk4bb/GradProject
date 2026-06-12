import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';

import '../../../domain/entities/quiz_entity.dart';

class QuizIntroScreen extends StatefulWidget {
  final QuizEntity quiz;

  const QuizIntroScreen({super.key, required this.quiz});

  @override
  State<QuizIntroScreen> createState() => _QuizIntroScreenState();
}

class _QuizIntroScreenState extends State<QuizIntroScreen> {
  bool _hasReadRules = false;

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF26C6DA),
                // Placeholder for actual image
                // image: DecorationImage(image: AssetImage('assets/images/course_cover.png'), fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    left: 24,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorsManager.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'CS-401',
                        style: AppLightTextStyles.labelSmall.copyWith(color: const Color(0xFF26C6DA), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.quiz.title,
                    style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quiz Information',
                    style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
                  ),
                  SizedBox(height: 24),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(isLight, Icons.timer_outlined, widget.quiz.durationMinutes.toString(), 'Minutes'),
                      _buildStatItem(isLight, Icons.quiz_outlined, widget.quiz.questionCount.toString(), 'Questions'),
                      _buildStatItem(isLight, Icons.stars_outlined, '${widget.quiz.totalMarks > 0 ? widget.quiz.totalMarks.toInt() : widget.quiz.questionCount * 10}', 'Total Marks'),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Rules Section
                  Text(
                    'Quiz Rules & Instructions',
                    style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isLight ? Colors.transparent : ColorsManager.grayMedium.withValues(alpha: 0.2)),
                      boxShadow: isLight
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRuleItem(isLight, 'The timer cannot be paused once started.'),
                        _buildRuleItem(isLight, 'Do not close or refresh the browser window.'),
                        _buildRuleItem(isLight, 'Ensure you have a stable internet connection.'),
                        _buildRuleItem(isLight, 'Unanswered questions will receive 0 marks.'),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _hasReadRules,
                        activeColor: const Color(0xFF26C6DA),
                        onChanged: (value) {
                          setState(() {
                            _hasReadRules = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I have read and agree to follow all instructions.',
                          style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayDark),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _hasReadRules
                          ? () {
                              Navigator.pushReplacementNamed(context, Routes.activeQuiz, arguments: {'quizId': widget.quiz.id});
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26C6DA),
                        disabledBackgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.3),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'START QUIZ',
                        style: TextStyle(
                          color: _hasReadRules ? ColorsManager.white : ColorsManager.grayMedium,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(bool isLight, IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF26C6DA), size: 24),
        ),
        SizedBox(height: 8),
        Text(value, style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium)),
      ],
    );
  }

  Widget _buildRuleItem(bool isLight, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: const Color(0xFF26C6DA)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
