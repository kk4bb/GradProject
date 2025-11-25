
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/language_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/app_sizes.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../widgets/settings_box.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isLight ? ColorsManager.black : ColorsManager.white,
            size: 22.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.settingsTitle,
          style: isLight
              ? AppLightTextStyles.appBarTitle
              : AppDarkTextStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: REdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPadding,
          vertical: AppSizes.verticalSectionSpacing,
        ),
        child: Column(
          children: [
            // Theme Settings
            SettingsBox(
              icon: IconsManager.theme,
              title: localizations.theme,
              subtitle: themeProvider.isDarkTheme()
                  ? localizations.dark
                  : localizations.light,
              hasSwitch: true,
              switchValue: themeProvider.isDarkTheme(),
              onToggle: (value) {
                themeProvider.changeAppTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              isLight: isLight,
            ),
            SizedBox(height: AppSizes.smallSpacing),

            // Language Settings
            SettingsBox(
              icon: IconsManager.language,
              title: localizations.language,
              subtitle: languageProvider.isArabic
                  ? localizations.arabic
                  : localizations.english,
              hasArrow: true,
              onTap: () => _showLanguageDialog(context, localizations),
              isLight: isLight,
            ),
            SizedBox(height: AppSizes.smallSpacing),

            // Notifications Settings
            SettingsBox(
              icon: IconsManager.notification,
              title: localizations.notifications,
              subtitle: localizations.on,
              hasSwitch: true,
              switchValue: true,
              onToggle: (value) {
                // TODO: Implement notification settings
              },
              isLight: isLight,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context,
      AppLocalizations localizations,
      ) {
    final themeProvider = context.read<ThemeProvider>();
    final languageProvider = context.read<LanguageProvider>();
    final isLight = themeProvider.isLightTheme();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        title: Text(
          localizations.language,
          style: TextStyle(
            color: isLight ? ColorsManager.black : ColorsManager.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context: dialogContext,
              label: localizations.english,
              languageCode: 'en',
              isSelected: languageProvider.currentLanguage == 'en',
              isLight: isLight,
              onTap: () {
                languageProvider.changeAppLanguage('en');
                Navigator.pop(dialogContext);
              },
            ),
            SizedBox(height: 12.h),
            _buildLanguageOption(
              context: dialogContext,
              label: localizations.arabic,
              languageCode: 'ar',
              isSelected: languageProvider.currentLanguage == 'ar',
              isLight: isLight,
              onTap: () {
                languageProvider.changeAppLanguage('ar');
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String label,
    required String languageCode,
    required bool isSelected,
    required bool isLight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isLight ? ColorsManager.lightBlue : ColorsManager.blue.withValues(alpha: 0.15))
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? ColorsManager.blue
                : (isLight ? ColorsManager.grayMedium.withValues(alpha: 0.3) : ColorsManager.grayMedium.withValues(alpha: 0.2)),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? ColorsManager.blue
                  : (isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary),
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}