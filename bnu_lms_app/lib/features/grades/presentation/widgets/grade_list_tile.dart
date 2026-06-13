import 'package:flutter/material.dart';

class GradeListTile extends StatelessWidget {
  final String title;
  final double score;
  final double maxScore;
  final IconData icon;

  const GradeListTile({
    Key? key,
    required this.title,
    required this.score,
    required this.maxScore,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (maxScore > 0) ? (score / maxScore).clamp(0.0, 1.0) : 0.0;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: score.toStringAsFixed(1),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getColor(percent, theme),
              ),
            ),
            TextSpan(
              text: ' / $maxScore',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(double percent, ThemeData theme) {
    if (percent >= 0.85) return Colors.green;
    if (percent >= 0.65) return theme.colorScheme.primary;
    if (percent >= 0.50) return Colors.orange;
    return Colors.red;
  }
}
