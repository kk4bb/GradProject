import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/network/repositories/attendance_repository.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../attendance/presentation/screens/attendance_qr_screen.dart';


class CourseAttendanceTab extends StatefulWidget {
  final int courseId;
  const CourseAttendanceTab({required this.courseId, super.key});

  @override
  State<CourseAttendanceTab> createState() => _CourseAttendanceTabState();
}

class _CourseAttendanceTabState extends State<CourseAttendanceTab> {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  late Future<List<CourseAttendanceReport>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = _attendanceRepository.getCourseAttendanceReport(widget.courseId);
  }

  Future<void> _takeAttendance() async {
    final titleController = TextEditingController(text: 'Lecture - ${DateTime.now().day}/${DateTime.now().month}');
    int duration = 15;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New Attendance Session'),
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
      try {
        // Show loading
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Capturing location and creating session...')),
        );

        // Get location
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
            courseId: widget.courseId,
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
        ).then((_) {
          // Refresh history when returning
          setState(() {
            _reportsFuture = _attendanceRepository.getCourseAttendanceReport(widget.courseId);
          });
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return FutureBuilder<List<CourseAttendanceReport>>(
      future: _reportsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final reports = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Take Attendance Button
              GestureDetector(
                onTap: _takeAttendance,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: ColorsManager.blue,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(color: ColorsManager.blue.withValues(alpha: 0.3), blurRadius: 12.0, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_reg, color: ColorsManager.white, size: 20.0),
                      SizedBox(width: 8.0),
                      Text(
                        'Take Attendance',
                        style: AppDarkTextStyles.labelLarge.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance History',
                    style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                  ),
                  Text(
                    'Filter',
                    style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              if (reports.isEmpty)
                const Center(child: Text('No attendance history found for this course.'))
              else
                ...reports.map((report) {
                  final presentCount = report.attendanceRecords.where((r) => r.isPresent).length;
                  final totalCount = report.attendanceRecords.length;
                  final presentPercentage = totalCount > 0 ? (presentCount / totalCount * 100).toInt() : 0;
                  final absentPercentage = 100 - presentPercentage;

                  return _buildAttendanceCard(
                    context,
                    '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                    report.sessionTitle,
                    presentPercentage,
                    absentPercentage,
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceCard(BuildContext context, String date, String sessionInfo, int present, int absent) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8.0, offset: const Offset(0, 2))]
            : [],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                  SizedBox(height: 4.0),
                  Text(sessionInfo, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: ColorsManager.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'COMPLETED',
                  style: AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.blue, fontSize: 10.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('$present%', style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(color: ColorsManager.blue)),
                  SizedBox(width: 8.0),
                  Text('PRESENT', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.0)),
                  SizedBox(width: 20.0),
                  Text('$absent%', style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(color: ColorsManager.red)),
                  SizedBox(width: 8.0),
                  Text('ABSENT', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.0)),
                ],
              ),
              Text('Details >', style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.grayMedium)),
            ],
          ),
        ],
      ),
    );
  }
}
