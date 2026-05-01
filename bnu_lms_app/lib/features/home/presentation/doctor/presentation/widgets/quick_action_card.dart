import 'package:flutter/material.dart';
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
        width: 171.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.lightBlue : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: ColorsManager.blue,
              size: 24.0,
            ),
            SizedBox(height: 8.0),
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