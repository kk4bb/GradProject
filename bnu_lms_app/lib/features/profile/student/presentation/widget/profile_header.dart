import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String department;
  final String studentId;
  final int year;
  final String profileImage;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.department,
    required this.studentId,
    required this.year,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorsManager.blue,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundImage: AssetImage(profileImage),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: isLight
                ? AppLightTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
            )
                : AppDarkTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            department,
            style: isLight
                ? AppLightTextStyles.bodyMedium.copyWith(
              color: ColorsManager.grayDark,
            )
                : AppDarkTextStyles.bodyMedium.copyWith(
              color: ColorsManager.darkTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip('ID: $studentId', isLight),
              SizedBox(width: 12.w),
              _buildInfoChip('Year: $year', isLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, bool isLight) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLight
            ? ColorsManager.lightBlueAccent
            : ColorsManager.darkBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: ColorsManager.blue,
        ),
      ),
    );
  }
}