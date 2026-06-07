import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/app_sizes.dart';
import '../../../../../shared/resources/assets_manager.dart';
import '../../../../../shared/resources/colors_manager.dart';

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    return Container(
      width: 358.w,
      decoration: BoxDecoration(
        color: isLight ? Colors.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          left: BorderSide(
            color: ColorsManager.blue,
            width: 4.w,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageIcon(
              AssetImage(IconsManager.think),
              size: 26,
              color: ColorsManager.blue,
            ),

            SizedBox(width: AppSizes.mediumSpacing),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: isLight
                        ? AppLightTextStyles.bodyLarge
                        : AppDarkTextStyles.bodyLarge,
                  ),

                  SizedBox(height: 6),

                  Text(
                    'This quiz covers the fundamental concepts of cellular structures, '
                        'functions, and processes as discussed in the third chapter '
                        'of the course.',
                    style: isLight
                        ? AppLightTextStyles.bodyMedium
                        : AppDarkTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
