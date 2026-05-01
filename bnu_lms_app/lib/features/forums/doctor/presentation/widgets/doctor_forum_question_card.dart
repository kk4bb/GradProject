import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DoctorForumQuestionCard extends StatelessWidget {
  final String authorName;
  final String timeAgo;
  final String tag;
  final String questionTitle;
  final String questionBody;
  final int replies;
  final int views;
  final String status;
  final Color statusColor;
  final bool hasParticipated;

  const DoctorForumQuestionCard({
    required this.authorName,
    required this.timeAgo,
    required this.tag,
    required this.questionTitle,
    required this.questionBody,
    required this.replies,
    required this.views,
    required this.status,
    required this.statusColor,
    required this.hasParticipated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: Offset(0, 2))] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(radius: 12, backgroundColor: ColorsManager.grayMedium),
                        SizedBox(width: 8),
                        Text(authorName, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text(tag, style: TextStyle(color: ColorsManager.blue, fontSize: 12)),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(questionTitle, style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(questionBody, maxLines: 2, overflow: TextOverflow.ellipsis, style: isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 14, color: ColorsManager.grayMedium),
                    SizedBox(width: 4),
                    Text('$replies replies', style: TextStyle(fontSize: 12, color: ColorsManager.grayMedium)),
                    SizedBox(width: 16),
                    Icon(Icons.visibility_outlined, size: 14, color: ColorsManager.grayMedium),
                    SizedBox(width: 4),
                    Text('$views', style: TextStyle(fontSize: 12, color: ColorsManager.grayMedium)),
                    Spacer(),
                    Text('REPLY >', style: TextStyle(fontSize: 12, color: ColorsManager.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // Action Bottom Bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: hasParticipated ? ColorsManager.blue.withValues(alpha: 0.1) : ColorsManager.blue,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasParticipated) Icon(Icons.check_circle, color: ColorsManager.blue, size: 16),
                SizedBox(width: 8),
                Text(
                  hasParticipated ? 'YOU PARTICIPATED IN THIS DISCUSSION' : 'ADD NEW REPLY',
                  style: TextStyle(
                    color: hasParticipated ? ColorsManager.blue : ColorsManager.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}