// lib/features/quizzes/presentation/widgets/quiz/quiz_header_widget.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/resources/colors_manager.dart';

class QuizHeaderWidget extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final String timeRemaining;
  final double progress;          // timer arc 0.0→1.0
  final double questionProgress;  // linear bar 0.0→1.0
  final VoidCallback onClose;

  const QuizHeaderWidget({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.timeRemaining,
    required this.progress,
    required this.questionProgress,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // ── Row: Timer | Q x of y | Close ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircularTimerWidget(timeRemaining: timeRemaining, progress: progress),
              Text(
                'Q $currentQuestion of $totalQuestions',
                style: AppLightTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.black,
                ),
              ),
              _CloseButton(onClose: onClose),
            ],
          ),

          SizedBox(height: 16),

          // ── Progress Bar ─────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: questionProgress,
              minHeight: 6,
              backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(ColorsManager.blue),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Circular Timer ──────────────────────────────────────────────────────────
class _CircularTimerWidget extends StatelessWidget {
  final String timeRemaining;
  final double progress;

  const _CircularTimerWidget({
    required this.timeRemaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          CustomPaint(
            size: Size(60, 60),
            painter: _ArcPainter(
              progress: progress,
              trackColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
              progressColor: ColorsManager.blue,
            ),
          ),
          // Time text
          Text(
            timeRemaining,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ColorsManager.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  const _ArcPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 3.5;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

// ── Close Button ─────────────────────────────────────────────────────────────
class _CloseButton extends StatelessWidget {
  final VoidCallback onClose;
  const _CloseButton({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: ColorsManager.grayMedium.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close_rounded, size: 20, color: ColorsManager.grayDark),
      ),
    );
  }
}
