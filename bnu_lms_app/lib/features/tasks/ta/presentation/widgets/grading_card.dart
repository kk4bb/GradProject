import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';

class GradingCard extends StatelessWidget {
  const GradingCard({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.code_rounded, color: cyan, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Due in 2 days',
                        style: TextStyle(fontSize: 12.sp, color: ColorsManager.grayMedium, fontWeight: FontWeight.w500)
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Data Structures - HW3',
                      style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '45/60 submissions pending',
                      style: TextStyle(fontSize: 13.sp, color: ColorsManager.grayMedium),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80.w,
                height: 32.h,
                child: Stack(
                  children: [
                    _buildAvatar(0, Colors.black),
                    _buildAvatar(20, Colors.orange),
                    _buildAvatar(40, ColorsManager.lightBlueAccent),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: cyan,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                ),
                child: Row(
                  children: [
                    Text(
                      'Go to Task',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.arrow_forward_rounded, size: 16.sp),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAvatar(double left, Color color) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(radius: 14.r, backgroundColor: color),
      ),
    );
  }
}