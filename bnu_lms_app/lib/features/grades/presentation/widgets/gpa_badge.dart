import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GPABadge extends StatelessWidget {
  final bool isLight;
  final double gpa;
  final String performance;

  const GPABadge({
    super.key,
    required this.isLight,
    this.gpa = 3.85,
    this.performance = 'Excellent',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isLight
            ? ColorsManager.lightBlueAccent
            : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 16.sp,
            color: isLight ? ColorsManager.blue : Colors.amber,
          ),
          SizedBox(width: 6.w),
          Text(
            'GPA: ${gpa.toStringAsFixed(2)} / $performance',
            style: isLight
                ? AppLightTextStyles.labelMedium
                : AppDarkTextStyles.labelMedium,
          ),
        ],
      ),
    );
  }
}