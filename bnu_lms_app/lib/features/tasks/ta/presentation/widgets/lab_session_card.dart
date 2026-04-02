import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class LabSessionCard extends StatelessWidget {
  const LabSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isLight ? const Color(0xFFF3F4F6) : ColorsManager.darkBackground,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Text('OCT', style: TextStyle(fontSize: 11.sp, color: ColorsManager.grayMedium, fontWeight: FontWeight.bold)),
                        Text('24', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: isLight ? Colors.black : Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CS201: Lab Section B',
                        style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                            .copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      SizedBox(height: 6.h),
                      Text('14:00 - 15:30 • Room 402', style: TextStyle(fontSize: 13.sp, color: ColorsManager.grayMedium)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.qr_code_rounded, color: cyan, size: 28.sp),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Attendance Pending', style: TextStyle(color: ColorsManager.grayMedium, fontSize: 14.sp)),
              Text('Mark Now', style: TextStyle(color: cyan, fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ],
          )
        ],
      ),
    );
  }
}