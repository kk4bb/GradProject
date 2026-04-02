import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SemesterTabs extends StatelessWidget {
  final bool isLight;

  const SemesterTabs({
    super.key,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: isLight ? Colors.grey[100] : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: isLight ? ColorsManager.blue : ColorsManager.blue,
          borderRadius: BorderRadius.circular(20.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: isLight ? Colors.white : Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: isLight
            ? AppLightTextStyles.labelMedium
            : AppDarkTextStyles.labelMedium,
        tabs: const [
          Tab(text: 'Fall 2024'),
          Tab(text: 'Spring 2025'),
          Tab(text: 'Summer 2025'),
        ],
      ),
    );
  }
}