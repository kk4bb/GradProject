import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/assets_manager.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class DoctorDashboardHeader extends StatelessWidget {
  const DoctorDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: ColorsManager.blue,
          child: ClipOval(
            child: Image.asset(
              ImagesManager.profileImage,
              fit: BoxFit.cover,
              width: 48.w,
              height: 48.h,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person);
              },
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Added this to center text vertically
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
                'Dr. Ahmed',
                style: isLight
                    ? AppLightTextStyles.labelLarge
                    : AppDarkTextStyles.labelLarge,
              ),
              Text(
                'Faculty of Engineering',
                style: isLight
                    ? AppLightTextStyles.labelLarge
                    : AppDarkTextStyles.labelLarge,
              ),
            ],
          ),
        ),
        // Row(
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         Navigator.pushNamed(context, Routes.notifications);
        //       },
        //       child: const ImageIcon(AssetImage(IconsManager.notification)),
        //     ),
        //     SizedBox(width: 20.w),
        //     GestureDetector(
        //       onTap: () {
        //         Navigator.pushNamed(context, Routes.settings);
        //       },
        //       child: const Icon(Icons.settings),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}