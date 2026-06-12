import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:provider/provider.dart';



class GradeSummaryCard extends StatelessWidget {
  final String title;
  final double score;
  final double maxScore;
  final String? subtitle;

  const GradeSummaryCard({
    Key? key,
    required this.title,
    required this.score,
    required this.maxScore,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();
    final percent = (maxScore > 0) ? (score / maxScore).clamp(0.0, 1.0) : 0.0;
    
    return Card(
      elevation: 4,
      color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ]
              ],
            ),
            CircularPercentIndicator(
              radius: 45.0,
              lineWidth: 10.0,
              animation: true,
              percent: percent,
              center: Text(
                '${score.toStringAsFixed(1)}\n/ $maxScore',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: _getColor(percent, theme),
              backgroundColor: isDarkMode ? ColorsManager.darkBackground : ColorsManager.lightBackground,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(double percent, ThemeData theme) {
    if (percent >= 0.85) return Colors.green;
    if (percent >= 0.65) return Colors.blue;
    if (percent >= 0.50) return Colors.orange;
    return Colors.red;
  }
}
