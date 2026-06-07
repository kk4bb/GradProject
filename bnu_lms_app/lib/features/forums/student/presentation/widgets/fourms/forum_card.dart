
import 'package:bnu_lms_app/features/forums/doctor/presentation/screens/doctor_forums_details_screen.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../data/forums_data.dart';


class ForumCard extends StatelessWidget {
  final ForumsData forum;

  const ForumCard({required this.forum, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorForumsDetailsScreen(courseName: forum.title),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isLight? ColorsManager.lightBlueAccent : ColorsManager.darkBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '#',
                  style: TextStyle(
                    color: ColorsManager.blue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forum.title,
                    style: isLight
                        ? AppLightTextStyles.labelLarge.copyWith(
                      color: ColorsManager.black,
                      fontWeight: FontWeight.w600,
                    )
                        : AppDarkTextStyles.labelLarge.copyWith(
                      color: ColorsManager.darkTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    forum.description,
                    style: isLight
                        ? AppLightTextStyles.labelMedium.copyWith(
                      color: ColorsManager.grayMedium,
                      fontSize: 13,
                    )
                        : AppDarkTextStyles.labelMedium.copyWith(
                      color: ColorsManager.darkTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}