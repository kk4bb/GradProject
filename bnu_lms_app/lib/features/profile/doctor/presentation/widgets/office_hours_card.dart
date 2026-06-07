import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class OfficeHoursCard extends StatelessWidget {
  const OfficeHoursCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.r, offset: const Offset(0, 4))] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_filled, color: ColorsManager.blue, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text('Office Hours', style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Text('EDIT', style: AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16.h),
          Text('Mon, Wed, Fri', style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
          SizedBox(height: 4.h),
          Text(
            '10:00 AM – 12:00 PM',
            style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_on, color: ColorsManager.grayMedium, size: 16.sp),
              SizedBox(width: 4.w),
              Text('Room 402, Academic Plaza', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}