import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class ForumQuestionCard extends StatelessWidget {
  final String authorName;
  final String timeAgo;
  final String questionTitle;
  final String questionBody;
  final int votes;
  final int commentsCount;
  final String status;
  final Color statusColor;
  final bool isPreview; // If true, truncates text for the list view

  const ForumQuestionCard({
    required this.authorName,
    required this.timeAgo,
    required this.questionTitle,
    required this.questionBody,
    required this.votes,
    required this.commentsCount,
    required this.status,
    required this.statusColor,
    this.isPreview = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: Offset(0, 2))] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status Tag & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                timeAgo,
                style: TextStyle(fontSize: 12, color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Title
          Text(
            questionTitle,
            style: isLight
                ? AppLightTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, color: ColorsManager.black, fontSize: 18)
                : AppDarkTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, color: ColorsManager.darkTextPrimary, fontSize: 18),
          ),
          SizedBox(height: 8),

          // Body
          Text(
            questionBody,
            maxLines: isPreview ? 3 : null,
            overflow: isPreview ? TextOverflow.ellipsis : null,
            style: isLight
                ? AppLightTextStyles.bodyMedium.copyWith(color: ColorsManager.grayDark, height: 1.5)
                : AppDarkTextStyles.bodyMedium.copyWith(color: ColorsManager.darkTextSecondary, height: 1.5),
          ),
          SizedBox(height: 16),

          Divider(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
          SizedBox(height: 8),

          // Footer: Author & Stats
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: ColorsManager.blue,
                child: Text(
                  authorName[0].toUpperCase(),
                  style: TextStyle(color: ColorsManager.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  authorName,
                  style: isLight
                      ? AppLightTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, color: ColorsManager.black)
                      : AppDarkTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, color: ColorsManager.darkTextPrimary),
                ),
              ),

              // Comments Icon
              Icon(Icons.chat_bubble_outline, size: 16, color: ColorsManager.grayMedium),
              SizedBox(width: 4),
              Text(
                commentsCount.toString(),
                style: TextStyle(fontSize: 13, color: ColorsManager.grayMedium, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),

              // Upvotes Icon
              Icon(Icons.thumb_up_alt_outlined, size: 16, color: ColorsManager.blue),
              SizedBox(width: 4),
              Text(
                votes.toString(),
                style: TextStyle(fontSize: 13, color: ColorsManager.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}