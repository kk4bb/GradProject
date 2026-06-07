import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';


class AssignmentItemCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final String status;
  final Color statusColor;

  const AssignmentItemCard({
    required this.title,
    required this.dueDate,
    required this.status,
    this.statusColor = Colors.orange,
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
              ? ColorsManager.grayMedium.withValues(alpha: 0.2)
              : ColorsManager.darkTextSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: ColorsManager.lightBlueAccent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.assignment,
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
                SizedBox(height: 4.h),
                Text(
                  'Due: $dueDate',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isLight
                        ? ColorsManager.grayMedium
                        : ColorsManager.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}