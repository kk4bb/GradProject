import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/assets_manager.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/routes_manager/routes.dart';

import '../../../../../../shared/network/repositories/student_repository.dart';
import '../../../../../profile/student/data/models/student_profile_model.dart';

class DoctorDashboardHeader extends StatefulWidget {
  const DoctorDashboardHeader({super.key});

  @override
  State<DoctorDashboardHeader> createState() => _DoctorDashboardHeaderState();
}

class _DoctorDashboardHeaderState extends State<DoctorDashboardHeader> {
  final StudentRepository _studentRepository = StudentRepository();
  late Future<StudentProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _studentRepository.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return FutureBuilder<StudentProfile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 48,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        
        final profile = snapshot.data;
        final name = profile != null ? 'Dr. ${profile.fullName}' : 'Doctor';
        final faculty = profile?.faculty ?? 'Faculty';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor: ColorsManager.blue,
              child: ClipOval(
                child: Image.asset(
                  ImagesManager.profileImage,
                  fit: BoxFit.cover,
                  width: 48.0,
                  height: 48.0,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.welcomeBack,
                    style: isLight
                        ? AppLightTextStyles.labelMedium.copyWith(
                      color: ColorsManager.blue,
                    )
                        : AppDarkTextStyles.labelMedium.copyWith(
                      color: ColorsManager.blue,
                    ),
                  ),
                  Text(
                    name,
                    style: isLight
                        ? AppLightTextStyles.labelLarge
                        : AppDarkTextStyles.labelLarge,
                  ),
                  Text(
                    faculty,
                    style: isLight
                        ? AppLightTextStyles.labelLarge
                        : AppDarkTextStyles.labelLarge,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.notifications);
                  },
                  child: const ImageIcon(AssetImage(IconsManager.notification)),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.settings);
                  },
                  child: const Icon(Icons.settings),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
