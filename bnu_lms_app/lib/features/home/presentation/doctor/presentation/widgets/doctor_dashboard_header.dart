import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/assets_manager.dart';
import '../../../../../../shared/resources/colors_manager.dart';

import 'package:bnu_lms_app/shared/network/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/assets_manager.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DoctorDashboardHeader extends StatefulWidget {
  const DoctorDashboardHeader({super.key});

  @override
  State<DoctorDashboardHeader> createState() => _DoctorDashboardHeaderState();
}

class _DoctorDashboardHeaderState extends State<DoctorDashboardHeader> {
  String _fullName = 'Instructor';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final firstName = await tokenStorage.getFirstName();
    final lastName = await tokenStorage.getLastName();
    final role = await tokenStorage.getRole();
    String prefix = '';
    if (role == 'Instructor') {
      prefix = 'Dr. ';
    } else if (role == 'TA') {
      prefix = 'TA. ';
    }
    
    if (mounted) {
      setState(() {
        _fullName = '$prefix${firstName ?? ""} ${lastName ?? ""}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: ColorsManager.blue,
          child: ClipOval(
            child: Image.asset(
              ImagesManager.profileImage,
              fit: BoxFit.cover,
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
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
                _fullName,
                style: isLight
                    ? AppLightTextStyles.labelLarge
                    : AppDarkTextStyles.labelLarge,
              ),
              Text(
                'Faculty of Engineering', // TODO: Fetch from storage if available
                style: isLight
                    ? AppLightTextStyles.labelLarge
                    : AppDarkTextStyles.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}