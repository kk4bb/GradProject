import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class TaForumReplyCard extends StatelessWidget {
  final String authorName;
  final String role;
  final String timeAgo;
  final String content;
  final int upvotes;
  final bool isSuggestedByTa;
  final bool canSuggestAsAnswer;

  const TaForumReplyCard({
    super.key,
    required this.authorName,
    required this.role,
    required this.timeAgo,
    required this.content,
    required this.upvotes,
    this.isSuggestedByTa = false,
    this.canSuggestAsAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    // Role styling
    Color roleColor;
    if (role == 'DOCTOR') {
      roleColor = Colors.purple;
    }
    else if (role.contains('TA')) {
      roleColor = cyan;
    }
    else {
      roleColor = ColorsManager.grayMedium;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        border: isSuggestedByTa ? Border.all(color: cyan.withValues(alpha: 0.5), width: 1.5) : null,
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Role
          Row(
            children: [
              CircleAvatar(radius: 16.0, backgroundColor: Colors.grey.shade300),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(authorName, style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.0)),
                        child: Text(role, style: TextStyle(color: roleColor, fontSize: 8.0, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Text(timeAgo, style: TextStyle(fontSize: 10.0, color: ColorsManager.grayMedium)),
                ],
              ),
              const Spacer(),
              if (isSuggestedByTa)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(color: cyan, borderRadius: BorderRadius.circular(6.0)),
                  child: Text('SUGGESTED BY TA', style: TextStyle(color: Colors.white, fontSize: 8.0, fontWeight: FontWeight.bold)),
                ),
            ],
          ),

          SizedBox(height: 12.0),

          // Body
          Text(
            content,
            style: TextStyle(fontSize: 13.0, color: isLight ? Colors.grey.shade800 : Colors.grey.shade300, height: 1.5),
          ),

          SizedBox(height: 16.0),

          // Footer: Upvotes & TA Actions
          Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 16.0, color: ColorsManager.grayMedium),
              SizedBox(width: 4.0),
              Text('$upvotes', style: TextStyle(fontSize: 12.0, color: ColorsManager.grayMedium)),
              SizedBox(width: 16.0),
              Icon(Icons.reply, size: 16.0, color: ColorsManager.grayMedium),
              SizedBox(width: 4.0),
              Text('Reply', style: TextStyle(fontSize: 12.0, color: ColorsManager.grayMedium)),

              const Spacer(),

              // 🔴 THE TA SPECIFIC ACTION BUTTON 🔴
              if (canSuggestAsAnswer)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check_circle_outline, size: 14.0, color: cyan),
                  label: Text('Suggest as Correct Answer', style: TextStyle(color: cyan, fontSize: 10.0, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cyan.withValues(alpha: 0.5)),
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    minimumSize: Size(0, 30.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),

              if (isSuggestedByTa)
                Text(
                  'Pending Doctor Approval',
                  style: TextStyle(color: Colors.orange, fontSize: 10.0, fontStyle: FontStyle.italic),
                ),
            ],
          )
        ],
      ),
    );
  }
}