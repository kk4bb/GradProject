import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../../../../shared/resources/colors_manager.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Row(
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
            children: [
              Text(localizations.welcomeBack, style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium ),
              Text('Mohamed', style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.notifications);
                },
                child: const ImageIcon(AssetImage(IconsManager.notification))),
            const SizedBox(width: 20),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.settings);
                },
                child: const Icon(Icons.settings)),
          ],
        )
      ],
    );
  }
}
