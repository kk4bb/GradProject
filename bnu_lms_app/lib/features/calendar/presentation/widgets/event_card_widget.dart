import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/calendar_event_entity.dart';
import 'package:intl/intl.dart';

class EventCardWidget extends StatelessWidget {
  final CalendarEventEntity event;

  const EventCardWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final typeColor = _typeColor(event.eventType);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.06 : 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: title + type badge ────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: typeColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  event.eventType,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          // ── Course title ───────────────────────────────────────────────────
          Text(
            event.courseTitle,
            style: TextStyle(
              fontSize: 12,
              color: ColorsManager.grayMedium,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // ── Description (only if non-empty) ────────────────────────────────
          if (event.description.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              event.description,
              style: TextStyle(
                fontSize: 11,
                color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: ColorsManager.grayMedium),
              SizedBox(width: 4),
              Text(
                DateFormat('dd/MM/yyyy hh:mm a').format(event.eventDate.toLocal()),
                style: TextStyle(
                  fontSize: 11,
                  color: ColorsManager.grayMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Quiz':
        return const Color(0xFF26C6DA);
      case 'Assignment':
        return ColorsManager.blue;
      case 'Lecture':
        return const Color(0xFF3B82F6); // distinct indigo-blue for Lecture
      default:
        return ColorsManager.green;
    }
  }
}
