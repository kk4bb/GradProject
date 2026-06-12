import 'package:flutter/material.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        color: isLight ? Colors.white : ColorsManager.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: ColorsManager.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'About this course',
                    style: isLight
                        ? AppLightTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.blue,
                          )
                        : AppDarkTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.blue,
                          ),
                  ),
                ],
              ),
              SizedBox(height: 16),
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
        ),
      ),
    );
  }
}
