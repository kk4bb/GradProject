import 'package:bnu_lms_app/shared/network/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DoctorProfileHeader extends StatefulWidget {
  const DoctorProfileHeader({super.key});

  @override
  State<DoctorProfileHeader> createState() => _DoctorProfileHeaderState();
}

class _DoctorProfileHeaderState extends State<DoctorProfileHeader> {
  String _fullName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final firstName = await tokenStorage.getFirstName();
    final lastName = await tokenStorage.getLastName();
    if (mounted) {
      setState(() {
        _fullName = 'Dr. ${firstName ?? ""} ${lastName ?? ""}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: ColorsManager.lightBlueAccent,
              child: CircleAvatar(
                radius: 42,
                backgroundColor: ColorsManager.grayMedium,
                child: Icon(Icons.person, size: 40, color: ColorsManager.white),
              ),
            ),
            // Verified Badge
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: ColorsManager.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: ColorsManager.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _fullName,
          style: isLight
              ? AppLightTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold)
              : AppDarkTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'ASSISTANT PROFESSOR',
          style: AppLightTextStyles.labelSmall.copyWith(
            color: ColorsManager.blue,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Computer Science Department', // TODO: Fetch from storage if available
          style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
        ),
      ],
    );
  }
}