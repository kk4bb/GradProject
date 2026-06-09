import 'package:bnu_lms_app/shared/network/token_storage.dart';
import 'package:bnu_lms_app/shared/network/repositories/assignment_repository.dart';
import 'package:bnu_lms_app/shared/network/repositories/quiz_repository.dart';
import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final courseRepo = CourseRepository();
      final assignmentRepo = AssignmentRepository();
      final quizRepo = QuizRepository();
      
      final role = await tokenStorage.getRole();
      final bool isStaff = role == 'DOCTOR' || role == 'Instructor' || role == 'TA';

      final courses = isStaff 
          ? await courseRepo.getAssignedCourses()
          : await courseRepo.getEnrolledCourses();
          
      Map<DateTime, List<String>> events = {};

      for (var course in courses) {
        final assignments = await assignmentRepo.getAssignments(course.id);
        for (var assignment in assignments) {
          final date = assignment.dueDate; 
          final normalizedDate = DateTime(date.year, date.month, date.day);
          events.putIfAbsent(normalizedDate, () => []).add('Assignment: ${assignment.title}');
        }

        final quizzes = await quizRepo.getQuizzes(course.id);
        // Quiz model currently lacks a dueDate.
        // Skipping quiz events for now.
      }
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.calendar,
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) => _events[DateTime(day.year, day.month, day.day)] ?? [],
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Expanded(
              child: ListView(
                children: (_events[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? [])
                    .map((event) => ListTile(
                          title: Text(event),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
    );
  }
}
