import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class TaForumCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String title;
  final String author;
  final String section;
  final int repliesCount;
  final String actionRequired;
  final bool isLight;
  final VoidCallback onTap;

  const TaForumCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.title,
    required this.author,
    required this.section,
    required this.repliesCount,
    required this.actionRequired,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                CircleAvatar(radius: 12.r, backgroundColor: Colors.orange.shade200),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isLight ? Colors.black : Colors.white)),
                    Text(section, style: TextStyle(fontSize: 10.sp, color: ColorsManager.grayMedium)),
                  ],
                ),
                const Spacer(),
                Text('2h ago', style: TextStyle(fontSize: 10.sp, color: ColorsManager.grayMedium)),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: ColorsManager.grayMedium.withValues(alpha: 0.1)),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 14.sp, color: ColorsManager.grayMedium),
                    SizedBox(width: 6.w),
                    Text('$repliesCount replies', style: TextStyle(fontSize: 12.sp, color: ColorsManager.grayMedium)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.error_outline, size: 14.sp, color: Colors.orange),
                    SizedBox(width: 4.w),
                    Text(
                      actionRequired,
                      style: TextStyle(fontSize: 11.sp, color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}