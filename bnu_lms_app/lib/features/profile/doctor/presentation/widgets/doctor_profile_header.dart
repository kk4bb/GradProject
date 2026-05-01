import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 46.0,
              backgroundColor: ColorsManager.lightBlueAccent,
              child: CircleAvatar(
                radius: 42.0,
                backgroundColor: ColorsManager.grayMedium,
                child: Icon(Icons.person, size: 40.0, color: ColorsManager.white),
              ),
            ),
            // Verified Badge
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  color: ColorsManager.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 12.0, color: ColorsManager.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Text(
          'Dr. Aris Thorne',
          style: isLight
              ? AppLightTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold)
              : AppDarkTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Text(
          'ASSISTANT PROFESSOR',
          style: AppLightTextStyles.labelSmall.copyWith(
            color: ColorsManager.blue,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          'Computer Science Department',
          style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
        ),
      ],
    );
  }
}