import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class MyCoursesSection extends StatelessWidget {
  const MyCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Courses', style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall),
            Text('View All', style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 16.0),
        _buildCourseItem(context, 'Advanced Algorithms', 'Fall 2024 • 42 Students', Icons.code),
        _buildCourseItem(context, 'Data Structures', 'Fall 2024 • 56 Students', Icons.storage),
      ],
    );
  }

  Widget _buildCourseItem(BuildContext context, String title, String subtitle, IconData icon) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8.0, offset: const Offset(0, 2))] : [],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: ColorsManager.lightBlueAccent,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: ColorsManager.blue, size: 24.0),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 4.0),
                Text(subtitle, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16.0, color: ColorsManager.grayMedium),
        ],
      ),
    );
  }
}