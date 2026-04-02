import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: isSuggestedByTa ? Border.all(color: cyan.withValues(alpha: 0.5), width: 1.5) : null,
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Role
          Row(
            children: [
              CircleAvatar(radius: 16.r, backgroundColor: Colors.grey.shade300),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(authorName, style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
                        child: Text(role, style: TextStyle(color: roleColor, fontSize: 8.sp, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Text(timeAgo, style: TextStyle(fontSize: 10.sp, color: ColorsManager.grayMedium)),
                ],
              ),
              const Spacer(),
              if (isSuggestedByTa)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(color: cyan, borderRadius: BorderRadius.circular(6.r)),
                  child: Text('SUGGESTED BY TA', style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold)),
                ),
            ],
          ),

          SizedBox(height: 12.h),

          // Body
          Text(
            content,
            style: TextStyle(fontSize: 13.sp, color: isLight ? Colors.grey.shade800 : Colors.grey.shade300, height: 1.5),
          ),

          SizedBox(height: 16.h),

          // Footer: Upvotes & TA Actions
          Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 16.sp, color: ColorsManager.grayMedium),
              SizedBox(width: 4.w),
              Text('$upvotes', style: TextStyle(fontSize: 12.sp, color: ColorsManager.grayMedium)),
              SizedBox(width: 16.w),
              Icon(Icons.reply, size: 16.sp, color: ColorsManager.grayMedium),
              SizedBox(width: 4.w),
              Text('Reply', style: TextStyle(fontSize: 12.sp, color: ColorsManager.grayMedium)),

              const Spacer(),

              // 🔴 THE TA SPECIFIC ACTION BUTTON 🔴
              if (canSuggestAsAnswer)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check_circle_outline, size: 14.sp, color: cyan),
                  label: Text('Suggest as Correct Answer', style: TextStyle(color: cyan, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cyan.withValues(alpha: 0.5)),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                    minimumSize: Size(0, 30.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                  ),
                ),

              if (isSuggestedByTa)
                Text(
                  'Pending Doctor Approval',
                  style: TextStyle(color: Colors.orange, fontSize: 10.sp, fontStyle: FontStyle.italic),
                ),
            ],
          )
        ],
      ),
    );
  }
}