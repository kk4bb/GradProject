import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class ForumAnswerCard extends StatelessWidget {
  final String authorName;
  final String role;
  final String timestamp;
  final String answerText;
  final int votes;
  final bool isTopRated;

  const ForumAnswerCard({
    required this.authorName,
    required this.role,
    required this.timestamp,
    required this.answerText,
    required this.votes,
    this.isTopRated = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTopRated)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: ColorsManager.green, size: 16),
                SizedBox(width: 6),
                Text(
                  'DOCTOR APPROVED ANSWER',
                  style: TextStyle(color: ColorsManager.green, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isLight
                ? (isTopRated ? ColorsManager.green.withValues(alpha: 0.05) : ColorsManager.white)
                : (isTopRated ? ColorsManager.green.withValues(alpha: 0.1) : ColorsManager.darkSurface),
            borderRadius: BorderRadius.circular(12),
            border: isTopRated ? Border.all(color: ColorsManager.green.withValues(alpha: 0.5), width: 1.5) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: ColorsManager.grayMedium,
                    child: Text(
                      authorName[0].toUpperCase(),
                      style: TextStyle(color: ColorsManager.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              authorName,
                              style: isLight
                                  ? AppLightTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, color: ColorsManager.black)
                                  : AppDarkTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, color: ColorsManager.darkTextPrimary),
                            ),
                            if (isTopRated) ...[
                              SizedBox(width: 4),
                              Icon(Icons.verified, color: ColorsManager.blue, size: 14),
                            ]
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          role,
                          style: TextStyle(fontSize: 10, color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (isTopRated)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorsManager.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text('Correct Answer', style: TextStyle(color: ColorsManager.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.check, color: ColorsManager.white, size: 12),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                answerText,
                style: isLight
                    ? AppLightTextStyles.bodyMedium.copyWith(color: ColorsManager.grayDark, height: 1.5)
                    : AppDarkTextStyles.bodyMedium.copyWith(color: ColorsManager.darkTextSecondary, height: 1.5),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildVoteButton(Icons.arrow_upward, isLight),
                  SizedBox(width: 12),
                  Text(
                    votes.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
                  ),
                  SizedBox(width: 12),
                  _buildVoteButton(Icons.arrow_downward, isLight),
                  Spacer(),
                  Text(
                    'Reply',
                    style: TextStyle(fontSize: 13, color: ColorsManager.grayMedium, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoteButton(IconData icon, bool isLight) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 16,
        color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
      ),
    );
  }
}