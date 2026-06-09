import 'package:bnu_lms_app/shared/network/token_storage.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
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
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))] : [],
          ),
          child: Column(
            children: [
              _buildSettingsItem(context, Icons.person_outline, 'Edit Profile'),
              _buildDivider(),
              _buildSettingsItem(context, Icons.lock_outline, 'Security & Password'),
              _buildDivider(),
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
              _buildSettingsItem(
                context,
                Icons.logout,
                'Log Out',
                isLogout: true,
                onTap: () async {
                  await tokenStorage.clearAll();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, {bool isLogout = false, VoidCallback? onTap}) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final textColor = isLogout ? ColorsManager.red : (isLight ? ColorsManager.black : ColorsManager.white);
    final iconColor = isLogout ? ColorsManager.red : ColorsManager.grayMedium;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        title,
        style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(
          color: textColor,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.w600,
        ),
      ),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16, color: ColorsManager.grayMedium),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: ColorsManager.grayMedium.withValues(alpha: 0.1));
  }
}