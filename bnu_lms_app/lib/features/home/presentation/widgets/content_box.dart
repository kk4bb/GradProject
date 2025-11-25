import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/resources/colors_manager.dart';

class ContentBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLight;
  final bool isArabic;

  const ContentBox({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isLight,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        border: !isLight
            ? Border.all(
                color: ColorsManager.darkBackground.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isLight
                  ? ColorsManager.blue.withValues(alpha: 0.1)
                  : ColorsManager.blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: isLight ? ColorsManager.blue : ColorsManager.lightBlue,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isLight ? ColorsManager.black : ColorsManager.white,
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isLight
                        ? ColorsManager.grayDark
                        : ColorsManager.grayMedium,
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
