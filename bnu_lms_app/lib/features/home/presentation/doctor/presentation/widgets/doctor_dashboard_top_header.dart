import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import 'doctor_dashboard_header.dart';

class DoctorDashboardTopHeader extends StatelessWidget {
  const DoctorDashboardTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      height: 170.0,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 24.0,
        right: 24.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DoctorDashboardHeader(),
          SizedBox(height: 14.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkSurface,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 16.0,
                  color: isLight ? ColorsManager.blue : Colors.amber,
                ),
                SizedBox(width: 6.0),
                Text(
                  'Monday, 24 Oct 2023',
                  style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}