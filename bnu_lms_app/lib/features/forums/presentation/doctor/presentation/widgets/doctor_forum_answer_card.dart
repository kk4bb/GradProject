import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DoctorForumAnswerCard extends StatelessWidget {
  final String authorName;
  final String timeAgo;
  final String answerText;
  final bool isCorrect;
  final VoidCallback onMarkCorrect;

  const DoctorForumAnswerCard({
    required this.authorName,
    required this.timeAgo,
    required this.answerText,
    required this.isCorrect,
    required this.onMarkCorrect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: isCorrect ? Border.all(color: ColorsManager.green, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 14, backgroundColor: ColorsManager.grayMedium),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(authorName, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.bold)),
                      Text(timeAgo, style: TextStyle(color: ColorsManager.grayMedium, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: onMarkCorrect,
                icon: Icon(isCorrect ? Icons.check_circle : Icons.check_circle_outline, color: isCorrect ? ColorsManager.white : ColorsManager.blue, size: 14),
                label: Text(
                  isCorrect ? 'CORRECT' : 'MARK AS CORRECT',
                  style: TextStyle(color: isCorrect ? ColorsManager.white : ColorsManager.blue, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isCorrect ? ColorsManager.green : Colors.transparent,
                  side: BorderSide(color: isCorrect ? ColorsManager.green : ColorsManager.blue),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  minimumSize: Size(0, 28),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(answerText, style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium),
        ],
      ),
    );
  }
}