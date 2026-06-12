import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../cubit/student_attendance_cubit.dart';
import '../cubit/student_attendance_state.dart';
import '../../domain/entities/course_attendance_report_entity.dart';

class StudentCourseAttendanceScreen extends StatelessWidget {
  final int courseId;
  final String courseName;

  const StudentCourseAttendanceScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudentAttendanceCubit>()..fetchDashboard(courseId),
      child: _StudentCourseAttendanceBody(
        courseId: courseId,
        courseName: courseName,
      ),
    );
  }
}

class _StudentCourseAttendanceBody extends StatelessWidget {
  final int courseId;
  final String courseName;

  const _StudentCourseAttendanceBody({
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final screenBg =
        isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground;
    final cardBg =
        isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final headlineStyle = isLight
        ? AppLightTextStyles.headlineSmall
        : AppDarkTextStyles.headlineSmall;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor:
            isLight ? ColorsManager.white : ColorsManager.darkSurface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          courseName,
          style:
              headlineStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: ColorsManager.blue,
            onPressed: () =>
                context.read<StudentAttendanceCubit>().fetchDashboard(courseId),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
        builder: (context, state) {
          if (state is StudentDashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.blue),
            );
          }

          if (state is StudentDashboardError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: ColorsManager.red, size: 48),
                    SizedBox(height: 12),
                    Text(state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorsManager.red, fontSize: 14)),
                  ],
                ),
              ),
            );
          }

          if (state is StudentDashboardLoaded) {
            final int present = state.presentCount;
            final int absent = state.absentCount;
            final double rate = state.attendanceRate;
            final List<CourseAttendanceReportEntity> reports = state.reports;

            // Flatten all log records
            final List<_LogEntry> logs = [];
            for (final report in reports) {
              for (final rec in report.attendanceRecords) {
                logs.add(_LogEntry(
                  sessionTitle: report.sessionTitle,
                  scannedAt: rec.scannedAt,
                  isPresent: rec.isPresent,
                ));
              }
            }
            logs.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));

            return RefreshIndicator(
              color: ColorsManager.blue,
              onRefresh: () =>
                  context.read<StudentAttendanceCubit>().fetchDashboard(courseId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stats summary ────────────────────────────────────────
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isLight
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${rate.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: ColorsManager.blue,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Attendance Rate',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsManager.grayMedium),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _StatChip(
                                  label: 'Present',
                                  value: present,
                                  color: ColorsManager.green),
                              SizedBox(width: 20),
                              _StatChip(
                                  label: 'Absent',
                                  value: absent,
                                  color: ColorsManager.red),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28),

                    // ── Logs ────────────────────────────────────────────────
                    Text(
                      'Attendance Logs',
                      style: (isLight
                              ? AppLightTextStyles.titleMedium
                              : AppDarkTextStyles.titleMedium)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),

                    if (logs.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            children: [
                              Icon(Icons.history_toggle_off_rounded,
                                  size: 40,
                                  color: ColorsManager.grayMedium),
                              SizedBox(height: 8),
                              Text(
                                'No attendance records yet.',
                                style: TextStyle(
                                    color: ColorsManager.grayMedium,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...logs.map((item) {
                        final timeStr = DateFormat('MMM dd, yyyy – hh:mm a')
                            .format(item.scannedAt);
                        return _LogCard(
                          sessionTitle: item.sessionTitle,
                          time: timeStr,
                          isPresent: item.isPresent,
                          cardBg: cardBg,
                          isLight: isLight,
                        );
                      }),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Internal data ─────────────────────────────────────────────────────────────

class _LogEntry {
  final String sessionTitle;
  final DateTime scannedAt;
  final bool isPresent;

  _LogEntry({
    required this.sessionTitle,
    required this.scannedAt,
    required this.isPresent,
  });
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style:
              TextStyle(fontSize: 12, color: ColorsManager.grayMedium),
        ),
      ],
    );
  }
}

class _LogCard extends StatelessWidget {
  final String sessionTitle;
  final String time;
  final bool isPresent;
  final Color cardBg;
  final bool isLight;

  const _LogCard({
    required this.sessionTitle,
    required this.time,
    required this.isPresent,
    required this.cardBg,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionTitle,
                  style: TextStyle(
                    color: isLight ? ColorsManager.black : ColorsManager.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                      fontSize: 11, color: ColorsManager.grayMedium),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (isPresent ? ColorsManager.green : ColorsManager.red)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPresent ? 'PRESENT' : 'ABSENT',
              style: TextStyle(
                color:
                    isPresent ? ColorsManager.green : ColorsManager.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
