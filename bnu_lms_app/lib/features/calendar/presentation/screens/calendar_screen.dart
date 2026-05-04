import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../home/presentation/student/data/models/student_dashboard_model.dart';
import '../../../../shared/network/repositories/student_repository.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final StudentRepository _studentRepository = StudentRepository();
  late Future<StudentDashboard> _dashboardFuture;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<UpcomingItem>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _dashboardFuture = _studentRepository.getDashboard();
  }

  List<UpcomingItem> _getEventsForDay(DateTime day) {
    // Normalize day to midnight for comparison
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  void _groupEvents(List<UpcomingItem> items) {
    _events = {};
    for (var item in items) {
      final date = DateTime(item.dueDate.year, item.dueDate.month, item.dueDate.day);
      if (_events[date] == null) {
        _events[date] = [];
      }
      _events[date]!.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? Colors.black : Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.calendar,
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
      ),
      body: FutureBuilder<StudentDashboard>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final dashboard = snapshot.data!;
          _groupEvents(dashboard.upcomingItems);

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: isLight ? Colors.white : ColorsManager.darkSurface,
                child: TableCalendar<UpcomingItem>(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: _getEventsForDay,
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: ColorsManager.blue.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: ColorsManager.blue,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: ColorsManager.red,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(color: isLight ? Colors.black : Colors.white),
                    weekendTextStyle: TextStyle(color: isLight ? Colors.black54 : Colors.white70),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge,
                    leftChevronIcon: Icon(Icons.chevron_left, color: isLight ? Colors.black : Colors.white),
                    rightChevronIcon: Icon(Icons.chevron_right, color: isLight ? Colors.black : Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _buildEventList(isLight),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventList(bool isLight) {
    final selectedEvents = _getEventsForDay(_selectedDay!);

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No events for this day',
          style: TextStyle(color: isLight ? Colors.grey : Colors.grey[400]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        final event = selectedEvents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: event.type == 'Assignment' ? ColorsManager.blue : ColorsManager.red,
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Icon(
              event.type == 'Assignment' ? Icons.assignment_outlined : Icons.quiz_outlined,
              color: event.type == 'Assignment' ? ColorsManager.blue : ColorsManager.red,
            ),
            title: Text(
              event.title,
              style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
            ),
            subtitle: Text(
              '${event.courseTitle} • Due at ${event.dueDate.hour}:${event.dueDate.minute.toString().padLeft(2, '0')}',
              style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (event.type == 'Assignment' ? ColorsManager.blue : ColorsManager.red).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                event.type.toUpperCase(),
                style: TextStyle(
                  color: event.type == 'Assignment' ? ColorsManager.blue : ColorsManager.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
