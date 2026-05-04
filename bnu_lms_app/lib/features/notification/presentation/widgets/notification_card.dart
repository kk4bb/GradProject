import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color indicatorColor;
  final bool isRead;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.indicatorColor,
    this.isRead = false,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 110.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Dot (only for unread)
          if (!isRead)
            Container(
              width: 10.0,
              height: 10.0,
              margin: const EdgeInsets.only(top: 6.0, right: 12.0),
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 22.0), // Spacer if no dot

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isLight
                      ? AppLightTextStyles.bodyMedium
                      : AppDarkTextStyles.bodyMedium.copyWith(color: ColorsManager.darkTextPrimary),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: isLight
                      ? AppLightTextStyles.bodySmall
                      : AppDarkTextStyles.bodySmall,
                ),
                const SizedBox(height: 8.0),
                Text(
                  time,
                  style: isLight
                      ? AppLightTextStyles.bodySmall
                      : AppDarkTextStyles.bodySmall,
                ),
              ],
            ),
          ),

          Column(
            children: [
              Icon(
                icon,
                color: isLight
                    ? ColorsManager.grayDark
                    : ColorsManager.darkTextSecondary,
                size: 20.0,
              ),
              if (!isRead && onMarkAsRead != null)
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 20, color: ColorsManager.blue),
                  onPressed: onMarkAsRead,
                  tooltip: 'Mark as read',
                ),
            ],
          )
        ],
      ),
    );
  }
}
