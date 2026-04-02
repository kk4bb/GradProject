import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class UrgentActionsSection extends StatelessWidget {
  const UrgentActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Urgent Actions',
                style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
              ),
              Text(
                'View All',
                style: AppLightTextStyles.labelMedium.copyWith(
                  color: const Color(0xFF2FBAD7), // TA Cyan
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Card 1: Urgent Review (Red)
          _buildUrgentCard(
            context,
            isLight,
            icon: Icons.priority_high_rounded,
            title: 'CS101 Final Project Review',
            subtitle: 'Due in 2 hours',
            buttonLabel: 'Start',
            baseColor: ColorsManager.red,
            isUrgent: true,
          ),
          SizedBox(height: 12.h),

          // Card 2: Meeting (Blue)
          _buildUrgentCard(
            context,
            isLight,
            icon: Icons.email_outlined,
            title: 'Meeting Request: Dr. Miller',
            subtitle: 'Course Syllabus Update',
            buttonLabel: 'Reply',
            baseColor: const Color(0xFF2FBAD7), // TA Cyan
            isUrgent: false,
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentCard(
      BuildContext context,
      bool isLight, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String buttonLabel,
        required Color baseColor,
        required bool isUrgent,
      }) {
    // Styling logic for Red vs Blue cards
    final bgColor = isLight
        ? baseColor.withValues(alpha: 0.08)
        : baseColor.withValues(alpha: 0.15);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: bgColor, width: 1),
        boxShadow: isLight
            ? [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
            : [],
      ),
      child: Row(
        children: [
          // Circular Icon
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: baseColor, // Solid color for icon bg
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 14.w),

          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall)
                      .copyWith(
                      color: isUrgent ? ColorsManager.red : ColorsManager.grayMedium,
                      fontWeight: isUrgent ? FontWeight.w600 : FontWeight.normal
                  ),
                ),
              ],
            ),
          ),

          // Action Button (Small pill)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isLight ? ColorsManager.white : ColorsManager.darkBackground,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: baseColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              buttonLabel,
              style: AppLightTextStyles.labelSmall.copyWith(
                color: baseColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}