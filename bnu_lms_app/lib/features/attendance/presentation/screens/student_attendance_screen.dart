import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../cubit/student_attendance_cubit.dart';
import '../cubit/student_attendance_state.dart';
import '../widgets/scanner_overlay_painter.dart';

class StudentAttendanceScreen extends StatelessWidget {
  final int courseId;

  const StudentAttendanceScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentAttendanceCubit>(),
      child: _StudentAttendanceScreenBody(courseId: courseId),
    );
  }
}

class _StudentAttendanceScreenBody extends StatefulWidget {
  final int courseId;

  const _StudentAttendanceScreenBody({
    required this.courseId,
  });

  @override
  State<_StudentAttendanceScreenBody> createState() => _StudentAttendanceScreenBodyState();
}

class _StudentAttendanceScreenBodyState extends State<_StudentAttendanceScreenBody> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final String rawCode = barcode.rawValue!.trim();
    if (rawCode.isEmpty) return;

    // Extract token: handle both plain GUID tokens and JSON wrappers like {"token":"abc123"}
    String token = rawCode;
    if (rawCode.startsWith('{') && rawCode.contains('token')) {
      try {
        // Simple key extraction without importing dart:convert
        final tokenMatch = RegExp(r'"token"\s*:\s*"([^"]+)"').firstMatch(rawCode);
        if (tokenMatch != null) {
          token = tokenMatch.group(1)!.trim();
        }
      } catch (_) {
        // If parsing fails, use rawCode as-is
      }
    }

    if (token.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    // Trigger StudentAttendanceCubit to mark attendance securely
    // ignore: use_build_context_synchronously
    context.read<StudentAttendanceCubit>().markAttendance(qrToken: token);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final cardBg = isLight ? ColorsManager.white : ColorsManager.darkSurface;
    final bodyStyle = isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium;

    return BlocConsumer<StudentAttendanceCubit, StudentAttendanceState>(
      listener: (context, state) async {
        if (state is StudentAttendanceSuccess) {
          final navigator = Navigator.of(context);
          // Success: auto pop after 5 seconds if not clicked manually
          await Future.delayed(const Duration(milliseconds: 5000));
          if (mounted) {
            navigator.pop(true);
          }
        } else if (state is StudentAttendanceError) {
          // Error: Allow user to scan again after 3 seconds
          await Future.delayed(const Duration(seconds: 3));
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
          }
        }
      },
      builder: (context, state) {
        if (state is StudentAttendanceSuccess) {
          return Scaffold(
            backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkBackground,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: ColorsManager.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.green.withValues(alpha: 0.15),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color: ColorsManager.green,
                        size: 80,
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      "Attendance Marked Successfully!",
                      textAlign: TextAlign.center,
                      style: (isLight
                              ? AppLightTextStyles.headlineSmall
                              : AppDarkTextStyles.headlineSmall)
                          .copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Verified via GPS & Device ID",
                      textAlign: TextAlign.center,
                      style: bodyStyle.copyWith(
                        color: ColorsManager.grayMedium,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: ColorsManager.blue, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Back to Dashboard",
                          style: TextStyle(
                            color: ColorsManager.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }

        String statusText = "Verifying Location & Device...";
        Color statusColor = ColorsManager.blue;
        IconData statusIcon = Icons.location_on_outlined;
        bool isLoading = false;

        if (state is StudentAttendanceLoading) {
          statusText = state.statusMessage;
          statusColor = ColorsManager.yellow;
          statusIcon = Icons.cloud_sync_outlined;
          isLoading = true;
        } else if (state is StudentAttendanceSuccess) {
          statusText = "Attendance Marked Successfully!";
          statusColor = ColorsManager.green;
          statusIcon = Icons.check_circle_outline_rounded;
        } else if (state is StudentAttendanceError) {
          statusText = state.message;
          statusColor = ColorsManager.red;
          statusIcon = Icons.error_outline_rounded;
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // ── Mobile Scanner View ───────────────────────────────────────────
              MobileScanner(
                controller: _scannerController,
                onDetect: _onDetect,
              ),

              // ── Custom Paint Overlay (Mask & Cutout & Corners) ────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: ScannerOverlayPainter(
                    cutoutSize: 260,
                    borderRadius: 16,
                  ),
                ),
              ),

              // ── App Bar Top Overlaid ──────────────────────────────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Scan QR Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Flashlight toggle button
                    ValueListenableBuilder(
                      valueListenable: _scannerController,
                      builder: (context, state, child) {
                        final isTorchOn = state.torchState == TorchState.on;
                        return IconButton(
                          icon: Icon(
                            isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => _scannerController.toggleTorch(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Instruction Text (Above Cutout) ──────────────────────────────
              Positioned(
                top: 200,
                left: 24,
                right: 24,
                child: const Center(
                  child: Text(
                    "Align QR code within the frame",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // ── Status Floating Bottom Card ──────────────────────────────────
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: cardBg.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          statusIcon,
                          color: statusColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLoading ? "Validating" : "System Status",
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorsManager.grayMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              statusText,
                              style: bodyStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (isLoading)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
