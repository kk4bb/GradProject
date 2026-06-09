import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Update these imports to match your actual file paths
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String value;
  final String title;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Access your theme provider
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: 180,
      height: 171,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Use your ColorsManager for the card background based on theme
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(24),
        // Shadows usually look best only in light mode, so we remove it in dark mode
        boxShadow: isLight
            ? [
          BoxShadow(
            color: ColorsManager.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const Spacer(),

          // Number Value (Using your headlineLarge which is 24 w600)
          Text(
            value,
            style: isLight
                ? AppLightTextStyles.headlineLarge
                : AppDarkTextStyles.headlineLarge,
          ),

          SizedBox(height: 4),

          // Subtitle (Using your labelMedium which is 14 w500)
          Text(
            title,
            style: isLight
                ? AppLightTextStyles.labelMedium
                : AppDarkTextStyles.labelMedium,
          ),
        ],
      ),
    );
  }
}