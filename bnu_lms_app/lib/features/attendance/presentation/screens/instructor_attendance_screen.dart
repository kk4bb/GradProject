import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../shared/config/api_constants.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../cubit/instructor_attendance_cubit.dart';
import '../cubit/instructor_attendance_state.dart';

class InstructorAttendanceScreen extends StatelessWidget {
  final int courseId;
  final int lectureId;

  const InstructorAttendanceScreen({
    super.key,
    required this.courseId,
    required this.lectureId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InstructorAttendanceCubit>()
        ..createSession(
          courseId: courseId,
          title: "Lecture #$lectureId",
          duration: 90,
          lat: 30.0712,
          lng: 31.2825,
        ),
      child: _InstructorAttendanceScreenBody(
        courseId: courseId,
        lectureId: lectureId,
      ),
    );
  }
}

class _InstructorAttendanceScreenBody extends StatefulWidget {
  final int courseId;
  final int lectureId;

  const _InstructorAttendanceScreenBody({
    required this.courseId,
    required this.lectureId,
  });

  @override
  State<_InstructorAttendanceScreenBody> createState() => _InstructorAttendanceScreenBodyState();
}

class _InstructorAttendanceScreenBodyState extends State<_InstructorAttendanceScreenBody> {
  String _qrToken = "";
  String _sessionTitle = "";
  int _studentsAttended = 0;
  Timer? _liveFetchTimer;
  Timer? _qrRefreshTimer;
  int _qrSecondsLeft = 90;
  bool _isMockScanning = false;

  @override
  void initState() {
    super.initState();
    _startLiveFetching();
    _startQrRefreshCountdown();
  }

  @override
  void dispose() {
    _liveFetchTimer?.cancel();
    _qrRefreshTimer?.cancel();
    super.dispose();
  }

  void _startLiveFetching() {
    _liveFetchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        context.read<InstructorAttendanceCubit>().fetchActiveAttendees(widget.courseId);
      }
    });
  }

  void _startQrRefreshCountdown() {
    _qrSecondsLeft = 90;
    _qrRefreshTimer?.cancel();
    _qrRefreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _qrSecondsLeft--;
      });
      if (_qrSecondsLeft <= 0) {
        timer.cancel();
        // Regenerate QR by creating a new session
        context.read<InstructorAttendanceCubit>().createSession(
          courseId: widget.courseId,
          title: "Lecture #${widget.lectureId}",
          duration: 90,
          lat: 30.0712,
          lng: 31.2825,
        );
        _startQrRefreshCountdown();
      }
    });
  }

  /// DEV ONLY: Fires a mock scan for emulator / presentation demo.
  Future<void> _fireMockScan() async {
    if (_isMockScanning) return;
    setState(() => _isMockScanning = true);

    try {
      final dio = getIt<Dio>();
      await dio.post('${ApiConstants.baseUrl}Attendance/mock-scan/${widget.courseId}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Mock scan fired! Counter will update shortly.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      if (mounted) {
        context.read<InstructorAttendanceCubit>().fetchActiveAttendees(widget.courseId);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mock scan failed: ${e.toString()}'),
          backgroundColor: ColorsManager.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isMockScanning = false);
    }
  }

  void _showAttendeesBottomSheet(BuildContext context) {
    context.read<InstructorAttendanceCubit>().fetchActiveAttendees(widget.courseId);

    final isLight = Provider.of<ThemeProvider>(context, listen: false).isLightTheme();
    final sheetBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final textStyle = isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium;
    final subtextStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<InstructorAttendanceCubit>(),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Attendees",
                      style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: BlocBuilder<InstructorAttendanceCubit, InstructorAttendanceState>(
                    builder: (context, state) {
                      if (state is InstructorAttendanceLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      List<dynamic> activeList = [];
                      if (state is InstructorAttendeesLoaded) {
                        activeList = state.attendees;
                      }

                      if (activeList.isEmpty) {
                        return Center(
                          child: Text(
                            "No students have checked in yet.",
                            style: subtextStyle.copyWith(color: ColorsManager.grayMedium),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: activeList.length,
                        itemBuilder: (context, index) {
                          final student = activeList[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: ColorsManager.blue.withValues(alpha: 0.1),
                              child: Text(
                                student.studentName.isNotEmpty ? student.studentName[0].toUpperCase() : 'S',
                                style: const TextStyle(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              student.studentName,
                              style: textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "ID: ${student.studentId.length > 8 ? student.studentId.substring(0, 8) : student.studentId}",
                              style: subtextStyle.copyWith(fontSize: 12, color: ColorsManager.grayMedium),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: ColorsManager.red),
                              onPressed: () {
                                _confirmRevoke(context, student.studentId, student.studentName);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmRevoke(BuildContext context, String studentId, String studentName) {
    final isLight = Provider.of<ThemeProvider>(context, listen: false).isLightTheme();
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final titleStyle = isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium;
    final bodyStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: cardBg,
        title: Text("Revoke Attendance", style: titleStyle.copyWith(fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to mark $studentName as absent?",
          style: bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text("Cancel", style: bodyStyle.copyWith(color: ColorsManager.grayMedium)),
          ),
          TextButton(
            onPressed: () {
              context.read<InstructorAttendanceCubit>().removeStudentFromAttendance(widget.courseId, studentId);
              Navigator.pop(dialogCtx);
            },
            child: Text("Revoke", style: bodyStyle.copyWith(color: ColorsManager.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final appBarBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final screenBg = isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground;
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;

    final headlineStyle = isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall;
    final titleStyle = isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium;
    final bodyStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    return BlocConsumer<InstructorAttendanceCubit, InstructorAttendanceState>(
      listener: (context, state) {
        if (state is InstructorSessionCreated) {
          setState(() {
            _qrToken = state.session.qrCodeToken;
            _sessionTitle = state.session.sessionTitle;
          });
        } else if (state is InstructorAttendeesLoaded) {
          setState(() {
            _studentsAttended = state.attendees.length;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: screenBg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Active Session",
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
              // 🐛 DEV: Mock scan button — simulates a student scan for emulator/presentation
              Tooltip(
                message: 'Simulate Student Scan (Demo Only)',
                child: _isMockScanning
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: const CircularProgressIndicator(strokeWidth: 2, color: ColorsManager.blue),
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.person_add_alt_1_rounded, color: ColorsManager.blue, size: 24),
                        onPressed: _fireMockScan,
                      ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),

                  Text(
                    _sessionTitle.isNotEmpty ? "$_sessionTitle — Attendance Session" : "Lecture #${widget.lectureId} — Attendance Session",
                    style: titleStyle.copyWith(fontWeight: FontWeight.bold, color: ColorsManager.blue),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),

                  // QR Refresh countdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 14, color: ColorsManager.grayMedium),
                      SizedBox(width: 4),
                      Text(
                        "QR refreshes in ${_qrSecondsLeft}s",
                        style: bodyStyle.copyWith(
                          color: _qrSecondsLeft <= 15 ? ColorsManager.red : ColorsManager.grayMedium,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // QR Code Card
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isLight
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))]
                          : [],
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state is InstructorAttendanceError)
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: Center(
                              child: Text(
                                state.message,
                                style: bodyStyle.copyWith(color: ColorsManager.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else if (state is InstructorAttendanceLoading || _qrToken.isEmpty)
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: const Center(child: CircularProgressIndicator()),
                          )
                        else
                          QrImageView(
                            data: _qrToken,
                            version: QrVersions.auto,
                            size: 240,
                            gapless: false,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: isLight ? ColorsManager.black : ColorsManager.white,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: isLight ? ColorsManager.black : ColorsManager.white,
                            ),
                          ),
                        // Countdown progress bar
                        if (_qrToken.isNotEmpty) ...[
                          SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _qrSecondsLeft / 90.0,
                              backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _qrSecondsLeft > 30
                                    ? ColorsManager.blue
                                    : _qrSecondsLeft > 15
                                        ? Colors.orange
                                        : ColorsManager.red,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // Attendance count — tap to view list
                  GestureDetector(
                    onTap: () => _showAttendeesBottomSheet(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: ColorsManager.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ColorsManager.blue.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Students Attended: $_studentsAttended",
                              style: bodyStyle.copyWith(
                                color: ColorsManager.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.keyboard_arrow_up_rounded, color: ColorsManager.blue, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Stop Attendance Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: cardBg,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Row(
                              children: [
                                const Icon(Icons.warning_rounded, color: ColorsManager.red),
                                SizedBox(width: 8),
                                Text("Stop Attendance", style: titleStyle.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            content: Text(
                              "Are you sure you want to end this attendance session?",
                              style: bodyStyle,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text("Cancel", style: bodyStyle.copyWith(color: ColorsManager.grayMedium)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsManager.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pop(context);
                                },
                                child: const Text("End Session", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text("Stop Attendance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
