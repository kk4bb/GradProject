import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';


class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final IconData icon;

  const UpcomingEventCard({
    required this.title,
    required this.date,
    required this.description,
    this.icon = Icons.event,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      margin: REdgeInsets.only(bottom: 12),
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isLight
              ? ColorsManager.grayMedium.withValues(alpha:0.2)
              : ColorsManager.darkTextSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: ColorsManager.lightBlueAccent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: ColorsManager.blue,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isLight
                      ? AppLightTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  )
                      : AppDarkTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: isLight
                      ? AppLightTextStyles.bodySmall.copyWith(
                    color: ColorsManager.grayDark,
                  )
                      : AppDarkTextStyles.bodySmall.copyWith(
                    color: ColorsManager.darkTextSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Posted on: $date',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isLight
                        ? ColorsManager.grayMedium
                        : ColorsManager.darkTextSecondary,
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