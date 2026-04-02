import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';

class TaTasksHeader extends StatelessWidget {
  const TaTasksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UNIVERSITY PORTAL',
          style: AppLightTextStyles.labelSmall.copyWith(
            color: cyan,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TA Tasks',
              style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge)
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 28.sp),
            ),
            Row(
              children: [
                _buildIconButton(context, Icons.search, isLight),
                SizedBox(width: 12.w),
                _buildIconButton(context, Icons.notifications_none_rounded, isLight),
              ],
            ),
          ],
        ),
        SizedBox(height: 24.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildFilterChip(context, 'All Tasks', isSelected: true),
              SizedBox(width: 12.w),
              _buildFilterChip(context, 'Grading', isSelected: false),
              SizedBox(width: 12.w),
              _buildFilterChip(context, 'Forum', isSelected: false),
              SizedBox(width: 12.w),
              _buildFilterChip(context, 'Attendance', isSelected: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, bool isLight) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isLight ? Colors.grey.shade100 : ColorsManager.darkSurface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 24.sp, color: isLight ? ColorsManager.black : ColorsManager.white),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, {required bool isSelected}) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? cyan : (isLight ? ColorsManager.white : ColorsManager.darkSurface),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: isLight && !isSelected
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : (isLight ? ColorsManager.black : ColorsManager.grayMedium),
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}