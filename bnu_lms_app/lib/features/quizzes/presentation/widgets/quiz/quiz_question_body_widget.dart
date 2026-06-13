// lib/features/quizzes/presentation/widgets/quiz/quiz_question_body_widget.dart

import 'package:flutter/material.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/resources/colors_manager.dart';
import 'quiz_option_card_widget.dart';

class QuizQuestionBodyWidget extends StatelessWidget {
  final String questionText;
  final String? imageUrl;
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onOptionSelected;

  const QuizQuestionBodyWidget({
    super.key,
    required this.questionText,
    required this.options,
    required this.onOptionSelected,
    this.imageUrl,
    this.selectedIndex,
  });

  static const List<String> _labels = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),

          // ── Question Text ──────────────────────────────────────────────
          Text(
            questionText,
            style: AppLightTextStyles.headlineSmall.copyWith(
              color: ColorsManager.black,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),

          SizedBox(height: 20),

          // ── Question Image (optional) ──────────────────────────────────
          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                imageUrl!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ImagePlaceholder(),
              ),
            ),
            SizedBox(height: 20),
          ] else ...[
            _ImagePlaceholder(),
            SizedBox(height: 20),
          ],

          // ── Options ────────────────────────────────────────────────────
          Text(
            'Choose one answer',
            style: AppLightTextStyles.bodySmall.copyWith(
              color: ColorsManager.grayMedium,
            ),
          ),

          SizedBox(height: 12),

          ...List.generate(options.length, (i) {
            return QuizOptionCardWidget(
              label: _labels[i],
              text: options[i],
              isSelected: selectedIndex == i,
              onTap: () => onOptionSelected(i),
            );
          }),

          SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ── Image Placeholder ────────────────────────────────────────────────────────
class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            ColorsManager.lightBlue,
            ColorsManager.lightBlueAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: ColorsManager.blue.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
