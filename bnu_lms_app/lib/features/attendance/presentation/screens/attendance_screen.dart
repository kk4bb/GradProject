import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import '../../../courses/presentation/cubit/courses_cubit/courses_state.dart';
import '../cubit/student_attendance_cubit.dart';
import '../cubit/student_attendance_state.dart';
import 'student_attendance_screen.dart';
import 'student_course_attendance_screen.dart';

class AttendanceScreen extends StatelessWidget {
  final int courseId;

  const AttendanceScreen({super.key, this.courseId = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoursesCubit>()..fetchEnrolledCourses(),
      child: const _AttendanceDashboardBody(),
    );
  }
}

class _AttendanceDashboardBody extends StatelessWidget {
  const _AttendanceDashboardBody();

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final screenBg =
        isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground;
    final appBarBg =
        isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final headlineStyle = isLight
        ? AppLightTextStyles.headlineSmall
        : AppDarkTextStyles.headlineSmall;
    final titleStyle = isLight
        ? AppLightTextStyles.titleMedium
        : AppDarkTextStyles.titleMedium;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Attendance',
          style: headlineStyle.copyWith(fontWeight: FontWeight.bold),
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
                context.read<CoursesCubit>().fetchEnrolledCourses(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.blue),
            );
          }

          if (state is CoursesError) {
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

          if (state is CoursesLoaded) {
            final courses = state.courses;

            if (courses.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school_outlined,
                          size: 48, color: ColorsManager.grayMedium),
                      SizedBox(height: 12),
                      Text('No enrolled courses found.',
                          style: TextStyle(
                              color: ColorsManager.grayMedium,
                              fontSize: 14)),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: ColorsManager.blue,
              onRefresh: () async =>
                  context.read<CoursesCubit>().fetchEnrolledCourses(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Scan CTA ────────────────────────────────────────────
                    _ScanCard(courses: courses),
                    SizedBox(height: 24),

                    // ── Section label ────────────────────────────────────────
                    Text(
                      'My Courses',
                      style: titleStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),

                    // ── Course cards ─────────────────────────────────────────
                    ...courses.map((course) => _CourseAttendanceCard(
                          course: course,
                          isLight: isLight,
                        )),
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

// ── Scan CTA Card ─────────────────────────────────────────────────────────────

class _ScanCard extends StatelessWidget {
  final List<CourseSummaryEntity> courses;

  const _ScanCard({required this.courses});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Use first course id as default for scanning, student scans QR which
        // already contains the session/course context on the backend.
        final int scanCourseId = courses.isNotEmpty ? courses.first.id : 0;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                StudentAttendanceScreen(courseId: scanCourseId),
          ),
        );
        // After returning, refresh courses list (stats may have changed)
        if (context.mounted) {
          context.read<CoursesCubit>().fetchEnrolledCourses();
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ColorsManager.blue, Color(0xFF1AA6C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.blue.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan Attendance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Mark present for today's lecture",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Course Attendance Card ────────────────────────────────────────────────────
// Each card has its own StudentAttendanceCubit scoped to the course.

class _CourseAttendanceCard extends StatelessWidget {
  final CourseSummaryEntity course;
  final bool isLight;

  const _CourseAttendanceCard({
    required this.course,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StudentAttendanceCubit>()..fetchDashboard(course.id),
      child: _CourseAttendanceCardContent(
        course: course,
        isLight: isLight,
      ),
    );
  }
}

class _CourseAttendanceCardContent extends StatelessWidget {
  final CourseSummaryEntity course;
  final bool isLight;

  const _CourseAttendanceCardContent({
    required this.course,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentCourseAttendanceScreen(
              courseId: course.id,
              courseName: course.title,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14),
        padding: EdgeInsets.all(18),
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
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ColorsManager.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.school_rounded,
                  color: ColorsManager.blue, size: 24),
            ),
            SizedBox(width: 14),

            // Title + stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isLight
                          ? ColorsManager.black
                          : ColorsManager.darkTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
                    builder: (context, state) {
                      if (state is StudentDashboardLoading) {
                        return SizedBox(
                          height: 14,
                          width: 80,
                          child: LinearProgressIndicator(
                            color: ColorsManager.blue,
                            backgroundColor: ColorsManager.blue
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }
                      if (state is StudentDashboardLoaded) {
                        return Row(
                          children: [
                            _MiniStat(
                              label: 'Rate',
                              value:
                                  '${state.attendanceRate.toStringAsFixed(0)}%',
                              color: ColorsManager.blue,
                            ),
                            SizedBox(width: 12),
                            _MiniStat(
                              label: 'Present',
                              value: '${state.presentCount}',
                              color: ColorsManager.green,
                            ),
                            SizedBox(width: 12),
                            _MiniStat(
                              label: 'Absent',
                              value: '${state.absentCount}',
                              color: ColorsManager.red,
                            ),
                          ],
                        );
                      }
                      if (state is StudentDashboardError) {
                        return Text(
                          'Unavailable',
                          style: TextStyle(
                              color: ColorsManager.grayMedium,
                              fontSize: 11),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ColorsManager.grayMedium,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(
              fontSize: 11,
              color: ColorsManager.grayMedium,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
