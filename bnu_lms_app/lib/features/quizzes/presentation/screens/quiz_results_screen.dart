import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/routes_manager/routes.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../data/models/quiz_model.dart';

class QuizResultsScreen extends StatelessWidget {
  final String quizTitle;
  final QuizResult result;

  const QuizResultsScreen({
    required this.quizTitle,
    required this.result,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: ColorsManager.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Congratulations!',
              style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'You have completed the quiz:',
              style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            ),
            Text(
              quizTitle,
              style: (isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge).copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isLight ? Colors.grey[100] : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildResultRow('Score', '${result.score.toStringAsFixed(1)}%', isLight),
                  const Divider(height: 32),
                  _buildResultRow('Correct Answers', '${result.correctAnswersCount} / ${result.totalQuestions}', isLight),
                ],
              ),
            ),
            const Spacer(),
            CustomElevatedButton(
              label: 'Back to Quizzes',
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName(Routes.main));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, bool isLight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: (isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge).copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.blue,
          ),
        ),
      ],
    );
  }
}
