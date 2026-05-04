import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../../../attendance/presentation/screens/attendance_qr_screen.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/network/api_service.dart';
import '../../../../../../shared/network/repositories/attendance_repository.dart';
import '../../../../../../shared/network/repositories/course_repository.dart';
import '../../../../../../shared/network/repositories/forum_repository.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/app_sizes.dart';
import '../../../../../courses/data/models/course_model.dart';
import 'quick_action_card.dart';

class DoctorQuickAccessSection extends StatefulWidget {
  const DoctorQuickAccessSection({super.key});

  @override
  State<DoctorQuickAccessSection> createState() => _DoctorQuickAccessSectionState();
}

class _DoctorQuickAccessSectionState extends State<DoctorQuickAccessSection> {
  final CourseRepository _courseRepository = CourseRepository();
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  final ForumRepository _forumRepository = ForumRepository();

  Future<void> _createAssignment() async {
    try {
      final courses = await _courseRepository.getAssignedCourses();
      if (courses.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No assigned courses found.')));
        return;
      }

      if (!mounted) return;
      final CourseSummary? selectedCourse = await showDialog<CourseSummary>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Course for Assignment'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(courses[index].title),
                onTap: () => Navigator.pop(context, courses[index]),
              ),
            ),
          ),
        ),
      );

      if (selectedCourse != null) {
        final titleController = TextEditingController();
        final descController = TextEditingController();
        DateTime selectedDate = DateTime.now().add(const Duration(days: 14));

        if (!mounted) return;
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: Text('New Assignment: ${selectedCourse.title}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                  TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 2),
                  ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setDialogState(() => selectedDate = picked);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
              ],
            ),
          ),
        );

        if (confirmed == true && titleController.text.isNotEmpty) {
          await apiService.dio.post(
            'assignment/course/${selectedCourse.id}/create',
            data: {
              'title': titleController.text,
              'description': descController.text,
              'dueDate': selectedDate.toIso8601String(),
            },
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assignment created successfully!')));
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _createQuiz() async {
    try {
      final courses = await _courseRepository.getAssignedCourses();
      if (courses.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No assigned courses found.')));
        return;
      }

      if (!mounted) return;
      final CourseSummary? selectedCourse = await showDialog<CourseSummary>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Course for Quiz'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(courses[index].title),
                onTap: () => Navigator.pop(context, courses[index]),
              ),
            ),
          ),
        ),
      );

      if (selectedCourse != null) {
        final titleController = TextEditingController();
        final descController = TextEditingController();
        DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

        if (!mounted) return;
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: Text('New Quiz: ${selectedCourse.title}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                  TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                  ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setDialogState(() => selectedDate = picked);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
              ],
            ),
          ),
        );

        if (confirmed == true && titleController.text.isNotEmpty) {
          await apiService.dio.post(
            'quiz/course/${selectedCourse.id}',
            data: {
              'title': titleController.text,
              'description': descController.text,
              'dueDate': selectedDate.toIso8601String(),
            },
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz created successfully!')));
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _postUpdate() async {
    try {
      final courses = await _courseRepository.getAssignedCourses();
      if (courses.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No assigned courses found.')),
        );
        return;
      }

      if (!mounted) return;
      final CourseSummary? selectedCourse = await showDialog<CourseSummary>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Course for Update'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(courses[index].title),
                onTap: () => Navigator.pop(context, courses[index]),
              ),
            ),
          ),
        ),
      );

      if (selectedCourse != null) {
        final titleController = TextEditingController();
        if (!mounted) return;
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Post New Update/Discussion'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Topic Title',
                hintText: 'e.g., Exam Schedule Update',
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Post'),
              ),
            ],
          ),
        );

        if (confirmed == true && titleController.text.isNotEmpty) {
          await _forumRepository.createDiscussion(selectedCourse.id, titleController.text);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Update posted successfully!')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _takeAttendance() async {
    try {
      final courses = await _courseRepository.getAssignedCourses();
      if (courses.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No assigned courses found.')),
        );
        return;
      }

      if (!mounted) return;
      final CourseSummary? selectedCourse = await showDialog<CourseSummary>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Course'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(courses[index].title),
                onTap: () => Navigator.pop(context, courses[index]),
              ),
            ),
          ),
        ),
      );

      if (selectedCourse != null) {
        final titleController = TextEditingController(text: 'Lecture - ${DateTime.now().day}/${DateTime.now().month}');
        int duration = 15;

        if (!mounted) return;
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: Text('New Session: ${selectedCourse.title}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Session Title'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Duration (minutes)'),
                  Slider(
                    value: duration.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 11,
                    label: duration.toString(),
                    onChanged: (value) {
                      setDialogState(() => duration = value.toInt());
                    },
                  ),
                  Text('$duration minutes'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        );

        if (confirmed == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Capturing location and creating session...')),
          );

          Position? position;
          try {
            LocationPermission permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
            }
            if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
              position = await Geolocator.getCurrentPosition();
            }
          } catch (e) {
            debugPrint('Location error: $e');
          }

          final response = await _attendanceRepository.createSession(
            CreateAttendanceSessionRequest(
              courseId: selectedCourse.id,
              sessionTitle: titleController.text,
              durationMinutes: duration,
              latitude: position?.latitude,
              longitude: position?.longitude,
            ),
          );

          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendanceQRScreen(
                sessionTitle: response.sessionTitle,
                qrCodeToken: response.qrCodeToken,
                expiresAt: response.expiresAt,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Text(
            localizations.quickAccess,
            style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.verticalSectionSpacing,
          ),
          child: GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 1,
            children: [
              QuickActionCard(
                icon: Icons.how_to_reg_outlined,
                label: 'Take Attendance',
                onTap: _takeAttendance,
              ),
              QuickActionCard(
                icon: Icons.assignment_add,
                label: 'Create Assignment',
                onTap: _createAssignment,
              ),
              QuickActionCard(
                icon: Icons.quiz_outlined,
                label: 'Create Quiz',
                onTap: _createQuiz,
              ),
              QuickActionCard(
                icon: Icons.campaign_outlined,
                label: 'Post Update',
                onTap: _postUpdate,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
