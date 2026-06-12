// lib/features/quizzes/presentation/widgets/quiz/quiz_bottom_nav_widget.dart

import 'package:flutter/material.dart';
import '../../../../../shared/resources/colors_manager.dart';

class QuizBottomNavWidget extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isFirstQuestion;
  final bool isLastQuestion;

  const QuizBottomNavWidget({
    super.key,
    required this.onPrevious,
    required this.onNext,
    this.isFirstQuestion = false,
    this.isLastQuestion  = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: ColorsManager.grayMedium.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Previous Button ──────────────────────────────────────────────
          Expanded(
            flex: 45,
            child: _OutlinedNavButton(
              label: 'Previous',
              icon: Icons.arrow_back_ios_new_rounded,
              iconOnLeft: true,
              onTap: isFirstQuestion ? null : onPrevious,
            ),
          ),

          SizedBox(width: 12),

          // ── Next / Submit Button ─────────────────────────────────────────
          Expanded(
            flex: 55,
            child: _FilledNavButton(
              label: isLastQuestion ? 'Submit' : 'Next',
              icon: isLastQuestion
                  ? Icons.check_circle_outline_rounded
                  : Icons.arrow_forward_ios_rounded,
              onTap: onNext,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Outlined Button ─────────────────────────────────────────────────────────
class _OutlinedNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool iconOnLeft;
  final VoidCallback? onTap;

  const _OutlinedNavButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconOnLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: disabled
                ? ColorsManager.grayMedium.withValues(alpha: 0.2)
                : ColorsManager.grayMedium.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconOnLeft) ...[
              Icon(icon,
                  size: 14,
                  color: disabled ? ColorsManager.grayMedium : ColorsManager.grayDark),
              SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: disabled ? ColorsManager.grayMedium : ColorsManager.grayDark,
              ),
            ),
            if (!iconOnLeft) ...[
              SizedBox(width: 6),
              Icon(icon,
                  size: 14,
                  color: disabled ? ColorsManager.grayMedium : ColorsManager.grayDark),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Filled Button ───────────────────────────────────────────────────────────
class _FilledNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _FilledNavButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: ColorsManager.blue,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.blue.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6),
            Icon(icon, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
