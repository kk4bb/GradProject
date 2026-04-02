import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';



class StudentSubmissionTile extends StatelessWidget {
  final String name;
  final String status;
  final Color? statusColor;
  final bool isGraded;

  const StudentSubmissionTile({
    super.key,
    required this.name,
    required this.status,
    required this.isGraded,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  status,
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor ?? ColorsManager.grayMedium
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isLight ? Colors.grey.shade100 : ColorsManager.darkBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isGraded ? Icons.edit_outlined : Icons.keyboard_arrow_down_rounded,
              size: 20.sp,
              color: isGraded ? const Color(0xFF2FBAD7) : ColorsManager.grayMedium,
            ),
          ),
        ],
      ),
    );
  }
}