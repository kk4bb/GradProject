import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/di/injection.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../attendance/domain/entities/course_attendance_report_entity.dart';
import '../../../../../../attendance/presentation/cubit/instructor_attendance_cubit.dart';
import '../../../../../../attendance/presentation/cubit/instructor_attendance_state.dart';
import '../../../../../../attendance/presentation/screens/instructor_attendance_screen.dart';
import '../../../../../../../shared/routes_manager/routes.dart';

class CourseAttendanceTab extends StatelessWidget {
  final int courseId;

  const CourseAttendanceTab({super.key, this.courseId = 1});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InstructorAttendanceCubit>()..fetchPastSessions(courseId),
      child: _CourseAttendanceTabBody(courseId: courseId),
    );
  }
}

class _CourseAttendanceTabBody extends StatelessWidget {
  final int courseId;

  const _CourseAttendanceTabBody({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return RefreshIndicator(
      onRefresh: () => context.read<InstructorAttendanceCubit>().fetchPastSessions(courseId),
      color: ColorsManager.blue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Take Attendance Button
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InstructorAttendanceScreen(
                      courseId: courseId,
                      lectureId: 1, // Defaulting to first lecture
                    ),
                  ),
                );
                // Refresh list if a new session was created
                if (result == true && context.mounted) {
                  context.read<InstructorAttendanceCubit>().fetchPastSessions(courseId);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.blue.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.how_to_reg, color: ColorsManager.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Take Attendance',
                      style: AppDarkTextStyles.labelLarge.copyWith(
                        color: ColorsManager.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance History',
                  style: isLight
                      ? AppLightTextStyles.headlineSmall
                      : AppDarkTextStyles.headlineSmall,
                ),
                Text(
                  'Live Sync',
                  style: AppLightTextStyles.labelMedium.copyWith(
                    color: ColorsManager.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            BlocBuilder<InstructorAttendanceCubit, InstructorAttendanceState>(
              builder: (context, state) {
                if (state is InstructorAttendanceLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: ColorsManager.blue),
                    ),
                  );
                } else if (state is InstructorAttendanceError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        state.message,
                        style: TextStyle(color: ColorsManager.red, fontSize: 14),
                      ),
                    ),
                  );
                } else if (state is InstructorHistoryLoaded) {
                  final reports = state.reports;
                  if (reports.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history_toggle_off_rounded,
                              size: 48,
                              color: ColorsManager.grayMedium,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "No past attendance sessions",
                              style: TextStyle(
                                color: ColorsManager.grayMedium,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      // Calculate Present and Absent percentages
                      final totalStudents = report.attendanceRecords.length;
                      final presentStudents = report.attendanceRecords.where((r) => r.isPresent).length;
                      final absentStudents = totalStudents - presentStudents;

                      final presentPct = totalStudents > 0 ? ((presentStudents / totalStudents) * 100).round() : 0;
                      final absentPct = totalStudents > 0 ? ((absentStudents / totalStudents) * 100).round() : 0;

                      // Format date e.g., "Monday, Oct 24"
                      final dateStr = "${_getWeekdayName(report.createdAt.weekday)}, ${_getMonthName(report.createdAt.month)} ${report.createdAt.day}";

                      return _buildAttendanceCard(
                        context,
                        report,
                        dateStr,
                        "Session #${report.sessionId} • ${report.sessionTitle}",
                        presentPct,
                        absentPct,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(
    BuildContext context,
    CourseAttendanceReportEntity report,
    String date,
    String sessionInfo,
    int present,
    int absent,
  ) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: isLight
                          ? AppLightTextStyles.titleMedium
                          : AppDarkTextStyles.titleMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      sessionInfo,
                      style: isLight
                          ? AppLightTextStyles.labelSmall
                          : AppDarkTextStyles.labelSmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorsManager.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'COMPLETED',
                  style: AppLightTextStyles.labelSmall.copyWith(
                    color: ColorsManager.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '$present%',
                    style: (isLight
                            ? AppLightTextStyles.headlineMedium
                            : AppDarkTextStyles.headlineMedium)
                        .copyWith(color: ColorsManager.blue),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'PRESENT',
                    style: (isLight
                            ? AppLightTextStyles.labelSmall
                            : AppDarkTextStyles.labelSmall)
                        .copyWith(fontSize: 10),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '$absent%',
                    style: (isLight
                            ? AppLightTextStyles.headlineMedium
                            : AppDarkTextStyles.headlineMedium)
                        .copyWith(color: ColorsManager.red),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ABSENT',
                    style: (isLight
                            ? AppLightTextStyles.labelSmall
                            : AppDarkTextStyles.labelSmall)
                        .copyWith(fontSize: 10),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.lectureAttendanceDetails,
                    arguments: {
                      'title': sessionInfo,
                      'date': date,
                      'attendees': report.attendanceRecords.where((r) => r.isPresent).toList(),
                    },
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'Details >',
                    style: AppLightTextStyles.labelMedium.copyWith(
                      color: ColorsManager.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if (weekday < 1 || weekday > 7) return 'Monday';
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month < 1 || month > 12) return 'Oct';
    return months[month - 1];
  }
}