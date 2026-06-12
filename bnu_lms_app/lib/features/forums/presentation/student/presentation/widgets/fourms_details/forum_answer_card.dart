import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/config/api_constants.dart';



class ForumAnswerCard extends StatelessWidget {
  final String authorName;
  final String role;
  final String timestamp;
  final String answerText;
  final int votes;
  final bool isTopRated;
  final String? approvedByRole;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final VoidCallback? onReplyTap;
  final String? authorAvatarUrl;

  const ForumAnswerCard({
    required this.authorName,
    required this.role,
    required this.timestamp,
    required this.answerText,
    required this.votes,
    this.isTopRated = false,
    this.approvedByRole,
    this.onUpvote,
    this.onDownvote,
    this.onReplyTap,
    this.authorAvatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    // Mention styling
    final List<TextSpan> textSpans = [];
    final words = answerText.split(' ');
    for (var word in words) {
      if (word.startsWith('@')) {
        textSpans.add(TextSpan(
          text: '$word ',
          style: TextStyle(color: ColorsManager.blue, fontWeight: FontWeight.w600),
        ));
      } else {
        textSpans.add(TextSpan(
          text: '$word ',
          style: isLight
              ? AppLightTextStyles.bodyMedium.copyWith(color: ColorsManager.grayDark, height: 1.5)
              : AppDarkTextStyles.bodyMedium.copyWith(color: ColorsManager.darkTextSecondary, height: 1.5),
        ));
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        border: Border(
          left: BorderSide(
            color: isTopRated ? ColorsManager.green : (isLight ? ColorsManager.grayMedium.withValues(alpha: 0.3) : ColorsManager.darkTextSecondary.withValues(alpha: 0.2)),
            width: 4,
          ),
          top: BorderSide(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : ColorsManager.darkTextSecondary.withValues(alpha: 0.1)),
          right: BorderSide(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : ColorsManager.darkTextSecondary.withValues(alpha: 0.1)),
          bottom: BorderSide(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : ColorsManager.darkTextSecondary.withValues(alpha: 0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Vote Column
            Container(
              width: 56,
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.lightBackground.withValues(alpha: 0.5) : ColorsManager.darkBackground.withValues(alpha: 0.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildVoteButton(Icons.keyboard_arrow_up, isLight, onUpvote),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      votes.toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
                    ),
                  ),
                  _buildVoteButton(Icons.keyboard_arrow_down, isLight, onDownvote),
                  if (isTopRated) ...[
                    const SizedBox(height: 12),
                    Icon(Icons.check, color: ColorsManager.green, size: 28),
                  ]
                ],
              ),
            ),
            
            // Right Content Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Author Name and Timestamp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: ColorsManager.blue,
                              child: ClipOval(
                                child: authorAvatarUrl != null && authorAvatarUrl!.isNotEmpty
                                    ? Image.network(
                                        authorAvatarUrl!.startsWith('http')
                                            ? authorAvatarUrl!
                                            : '${ApiConstants.baseUrl.replaceAll('api/', '')}${authorAvatarUrl!.startsWith('/') ? authorAvatarUrl!.substring(1) : authorAvatarUrl!}',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Text(
                                          authorName.isNotEmpty ? authorName[0].toUpperCase() : 'U',
                                          style: TextStyle(color: ColorsManager.white, fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                      )
                                    : Text(
                                        authorName.isNotEmpty ? authorName[0].toUpperCase() : 'U',
                                        style: TextStyle(color: ColorsManager.white, fontWeight: FontWeight.bold, fontSize: 10),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              authorName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isLight ? ColorsManager.blue : ColorsManager.blue,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          timestamp,
                          style: TextStyle(fontSize: 12, color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (isTopRated)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Icon(Icons.verified, color: ColorsManager.green, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              approvedByRole == 'TA' ? 'CORRECTED BY TA' : 'DOCTOR APPROVED ANSWER',
                              style: TextStyle(color: ColorsManager.green, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    
                    // Answer Content
                    RichText(
                      text: TextSpan(children: textSpans),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Bottom Row: Reply
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: onReplyTap,
                          child: Text(
                            'Reply',
                            style: TextStyle(fontSize: 13, color: ColorsManager.grayMedium, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteButton(IconData icon, bool isLight, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 28,
          color: ColorsManager.grayMedium,
        ),
      ),
    );
  }
}