import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';


class GradingSummaryCard extends StatelessWidget {
  final String assignmentTitle;

  const GradingSummaryCard({super.key, required this.assignmentTitle});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  assignmentTitle,
                  style: (isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: cyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'ACTIVE',
                  style: TextStyle(color: cyan, fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Due: Oct 24, 2023 • 11:59 PM',
            style: TextStyle(color: ColorsManager.grayMedium, fontSize: 12.sp),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(child: _buildStatBox(isLight, 'TOTAL\nSUBMISSIONS', '45', Colors.transparent)),
              SizedBox(width: 12.w),
              Expanded(child: _buildStatBox(isLight, 'PENDING\nGRADE', '12', cyan.withValues(alpha: 0.05))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatBox(bool isLight, String label, String value, Color bgColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isLight && bgColor == Colors.transparent ? Colors.grey.shade50 : bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.grayMedium,
                letterSpacing: 1.0
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}