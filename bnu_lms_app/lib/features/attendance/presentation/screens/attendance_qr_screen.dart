import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import 'package:provider/provider.dart';
import '../../../../shared/providers/theme_provider.dart';

class AttendanceQRScreen extends StatelessWidget {
  final String sessionTitle;
  final String qrCodeToken;
  final DateTime expiresAt;

  const AttendanceQRScreen({
    required this.sessionTitle,
    required this.qrCodeToken,
    required this.expiresAt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final remainingMinutes = expiresAt.difference(DateTime.now()).inMinutes;

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        title: const Text('Attendance QR Code'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isLight ? Colors.black : Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sessionTitle,
                style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Students should scan this code to mark attendance',
                style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20.0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrCodeToken,
                  version: QrVersions.auto,
                  size: 280.0,
                  gapless: false,
                ),
              ),
              const SizedBox(height: 40.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: ColorsManager.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, color: ColorsManager.blue, size: 20.0),
                    const SizedBox(width: 8.0),
                    Text(
                      'Expires in $remainingMinutes minutes',
                      style: AppLightTextStyles.labelLarge.copyWith(
                        color: ColorsManager.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60.0),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text('Finish Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
