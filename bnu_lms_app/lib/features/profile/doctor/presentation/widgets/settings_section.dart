import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.r, offset: const Offset(0, 4))] : [],
          ),
          child: Column(
            children: [
              _buildSettingsItem(context, Icons.person_outline, 'Edit Profile'),
              _buildDivider(),
              _buildSettingsItem(context, Icons.lock_outline, 'Security & Password'),
              _buildDivider(),
              // Passed the onTap directly into the method here
              _buildSettingsItem(
                context,
                Icons.language_outlined,
                'Theme and Language',
                onTap: () {
                  Navigator.pushNamed(context, Routes.settings);
                },
              ),
              _buildDivider(),
              _buildSettingsItem(context, Icons.help_outline, 'Help Center'),
              _buildDivider(),
              _buildSettingsItem(context, Icons.logout, 'Log Out', isLogout: true),
            ],
          ),
        ),
      ],
    );
  }

  // Added VoidCallback? onTap to the parameters
  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, {bool isLogout = false, VoidCallback? onTap}) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final textColor = isLogout ? ColorsManager.red : (isLight ? ColorsManager.black : ColorsManager.white);
    final iconColor = isLogout ? ColorsManager.red : ColorsManager.grayMedium;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Icon(icon, color: iconColor, size: 24.sp),
      title: Text(
        title,
        style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(
          color: textColor,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.w600,
        ),
      ),
      trailing: isLogout ? null : Icon(Icons.arrow_forward_ios, size: 16.sp, color: ColorsManager.grayMedium),
      // Assigned the onTap parameter to the ListTile
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: ColorsManager.grayMedium.withValues(alpha: 0.1));
  }
}