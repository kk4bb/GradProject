// lib/features/quizzes/presentation/widgets/quiz/quiz_option_card_widget.dart

import 'package:flutter/material.dart';
import '../../../../../shared/resources/colors_manager.dart';

class QuizOptionCardWidget extends StatelessWidget {
  final String label;      // e.g. "A"
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizOptionCardWidget({
    super.key,
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final teal = ColorsManager.blue;
    final bgColor   = isSelected ? teal.withValues(alpha: 0.10) : Colors.white;
    final border    = isSelected
        ? Border.all(color: teal, width: 1.8)
        : Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.3), width: 1.2);
    final iconColor = isSelected ? teal : ColorsManager.grayMedium;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(32),
          border: border,
          boxShadow: isSelected
              ? [BoxShadow(color: teal.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // ── Radio Icon ────────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Icon(Icons.radio_button_checked_rounded,
                      key: const ValueKey('checked'),
                      color: teal,
                      size: 22)
                  : Icon(Icons.radio_button_off_rounded,
                      key: const ValueKey('unchecked'),
                      color: iconColor,
                      size: 22),
            ),

            SizedBox(width: 12),

            // ── Option Label (A / B / C / D) ──────────────────────────────
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? teal : ColorsManager.grayMedium.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : ColorsManager.grayDark,
                ),
              ),
            ),

            SizedBox(width: 12),

            // ── Option Text ───────────────────────────────────────────────
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? teal : ColorsManager.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
