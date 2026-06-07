import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 171.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.lightBlue : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: ColorsManager.blue,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: isLight
                  ? AppLightTextStyles.labelMedium.copyWith(
                color: ColorsManager.blue,
                fontWeight: FontWeight.w600, // Made slightly bolder for a button
              )
                  : AppDarkTextStyles.labelMedium.copyWith(
                color: ColorsManager.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}