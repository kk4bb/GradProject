import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DoctorProfileHeader extends StatelessWidget {
  final String name;
  final String department;
  final String role;
  final String? profilePictureUrl;
  
  const DoctorProfileHeader({
    required this.name,
    required this.department,
    required this.role,
    this.profilePictureUrl,
    super.key,
  });

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
                backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.1),
                child: ClipOval(
                  child: profilePictureUrl != null && profilePictureUrl!.isNotEmpty
                      ? Image.network(
                          profilePictureUrl!.startsWith('http') 
                              ? profilePictureUrl! 
                              : '${ApiConstants.baseUrl.replaceAll('api/', '')}${profilePictureUrl!.startsWith('/') ? profilePictureUrl!.substring(1) : profilePictureUrl!}',
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 40, color: ColorsManager.white),
                        )
                      : Icon(Icons.person, size: 40, color: ColorsManager.white),
                ),
              ),
            ),
            // Verified Badge
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: ColorsManager.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 12, color: ColorsManager.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          name,
          style: isLight
              ? AppLightTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold)
              : AppDarkTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          role.toUpperCase(),
          style: AppLightTextStyles.labelSmall.copyWith(
            color: ColorsManager.blue,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          department,
          style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
        ),
      ],
    );
  }
}