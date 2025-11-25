import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color indicatorColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 110.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Dot
          Container(
            width: 10.w,
            height: 10.w,
            margin: EdgeInsets.only(top: 6.h, right: 12.w),
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isLight
                      ? AppLightTextStyles.notificationTitle
                      : AppDarkTextStyles.notificationTitle,
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: isLight
                      ? AppLightTextStyles.notificationDescription
                      : AppDarkTextStyles.notificationDescription,
                ),
                SizedBox(height: 8.h),
                Text(
                  time,
                  style: isLight
                      ? AppLightTextStyles.notificationTime
                      : AppDarkTextStyles.notificationTime,
                ),
              ],
            ),
          ),

          // Right icon (color adjusts to theme)
          Icon(
            icon,
            color: isLight
                ? ColorsManager.grayDark
                : ColorsManager.darkTextSecondary,
            size: 20.sp,
          )
        ],
      ),
    );
  }
}
