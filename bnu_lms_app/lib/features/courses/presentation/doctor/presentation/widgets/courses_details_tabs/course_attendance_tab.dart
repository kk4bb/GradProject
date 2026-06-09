import 'package:bnu_lms_app/shared/network/repositories/attendance_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';


class CourseAttendanceTab extends StatefulWidget {
  final int courseId;
  const CourseAttendanceTab({required this.courseId, super.key});

  @override
  State<CourseAttendanceTab> createState() => _CourseAttendanceTabState();
}

class _CourseAttendanceTabState extends State<CourseAttendanceTab> {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  List<CourseAttendanceReport> _reports = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    try {
      final reports = await _attendanceRepository.getCourseAttendanceReport(widget.courseId);
      if (mounted) {
        setState(() {
          _reports = reports;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Take Attendance Button
          GestureDetector(
            onTap: () {
              // TODO: Navigate to create session
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: ColorsManager.blue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: ColorsManager.blue.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.how_to_reg, color: ColorsManager.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Take Attendance',
                    style: AppDarkTextStyles.labelLarge.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance History',
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
              ),
              Text(
                'Monthly View',
                style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_reports.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('No attendance sessions found.'),
            ))
          else
            ..._reports.map((report) {
              final presentCount = report.attendanceRecords.count((r) => r.isPresent);
              final totalCount = report.attendanceRecords.length;
              final presentPercentage = totalCount > 0 ? (presentCount * 100 / totalCount).toInt() : 0;
              final absentPercentage = 100 - presentPercentage;

              return _buildAttendanceCard(
                context,
                report.createdAt.toString().split(' ')[0], // Simple date
                report.sessionTitle,
                presentPercentage,
                absentPercentage,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, String date, String sessionInfo, int present, int absent) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]
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
                  const SizedBox(height: 4),
                  Text(sessionInfo, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorsManager.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'COMPLETED',
                  style: AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.blue, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('$present%', style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(color: ColorsManager.blue)),
                  const SizedBox(width: 8),
                  Text('PRESENT', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10)),
                  const SizedBox(width: 20),
                  Text('$absent%', style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(color: ColorsManager.red)),
                  const SizedBox(width: 8),
                  Text('ABSENT', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10)),
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

extension IterableExtension<T> on Iterable<T> {
  int count(bool Function(T element) test) {
    var count = 0;
    for (var element in this) {
      if (test(element)) count++;
    }
    return count;
  }
}
