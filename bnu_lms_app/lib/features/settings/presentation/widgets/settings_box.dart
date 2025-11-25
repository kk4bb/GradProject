import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/resources/colors_manager.dart';

class SettingsBox extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool hasSwitch;
  final bool? switchValue;
  final Function(bool)? onToggle;
  final bool hasArrow;
  final VoidCallback? onTap;
  final bool isLight;

  const SettingsBox({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.hasSwitch = false,
    this.switchValue,
    this.onToggle,
    this.hasArrow = false,
    this.onTap,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasArrow ? onTap : null,
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            // Icon container
            Container(
              padding: REdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLight
                    ? ColorsManager.blue.withValues(alpha: 0.1)
                    : ColorsManager.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                icon,
                width: 24.w,
                height: 24.h,
                color: isLight ? ColorsManager.blue : ColorsManager.lightBlue,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.settings,
                    size: 24.sp,
                    color:
                        isLight ? ColorsManager.blue : ColorsManager.lightBlue,
                  );
                },
              ),
            ),
            SizedBox(width: 16.w),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isLight ? ColorsManager.black : ColorsManager.white,
                    ),
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
                  ),
                ],
              ),
            ),

            // Switch or Arrow
            if (hasSwitch)
              Switch(
                value: switchValue ?? false,
                onChanged: onToggle,
                activeThumbColor: ColorsManager.blue,
                activeTrackColor: ColorsManager.blue.withValues(alpha: 0.5),
              )
            else if (hasArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 18.sp,
                color:
                    isLight ? ColorsManager.grayDark : ColorsManager.grayMedium,
              ),
          ],
        ),
      ),
    );
  }
}
