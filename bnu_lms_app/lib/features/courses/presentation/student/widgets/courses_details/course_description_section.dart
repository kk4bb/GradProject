import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class CourseDescriptionSection extends StatelessWidget {
  final String description;

  const CourseDescriptionSection({
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Description',
            style: isLight
                ? AppLightTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            )
                : AppDarkTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: isLight
                ? AppLightTextStyles.bodyMedium.copyWith(
              color: ColorsManager.grayDark,
              height: 1.6,
            )
                : AppDarkTextStyles.bodyMedium.copyWith(
              color: ColorsManager.darkTextSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
