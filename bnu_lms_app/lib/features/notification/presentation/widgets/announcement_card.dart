import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

enum AnnouncementUrgency { info, reminder, urgent }

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String course;
  final String target;
  final String time;
  final int reachCount;
  final bool isPinned;
  final AnnouncementUrgency urgency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.course,
    required this.target,
    required this.time,
    required this.reachCount,
    this.isPinned = false,
    this.urgency = AnnouncementUrgency.info,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  Color _getUrgencyColor() {
    switch (urgency) {
      case AnnouncementUrgency.urgent:
        return ColorsManager.red;
      case AnnouncementUrgency.reminder:
        return Colors.orange;
      case AnnouncementUrgency.info:
      return ColorsManager.grayMedium;
    }
  }

  String _getUrgencyText() {
    switch (urgency) {
      case AnnouncementUrgency.urgent:
        return 'URGENT';
      case AnnouncementUrgency.reminder:
        return 'REMINDER';
      case AnnouncementUrgency.info:
      return 'INFO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'To: $target',
                  style: TextStyle(
                    color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isPinned) ...[
                    Icon(Icons.push_pin, size: 14, color: ColorsManager.blue),
                    SizedBox(width: 4),
                  ],
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getUrgencyText(),
                      style: TextStyle(
                        color: _getUrgencyColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            course,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 16),
          Divider(color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                  SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.remove_red_eye_outlined, size: 14, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                  SizedBox(width: 4),
                  Text(
                    '$reachCount Reached',
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onView,
                    child: Icon(Icons.open_in_new, size: 20, color: ColorsManager.blue),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(Icons.edit_outlined, size: 20, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(Icons.delete_outline, size: 20, color: ColorsManager.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
