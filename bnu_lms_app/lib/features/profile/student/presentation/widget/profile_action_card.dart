import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isLight
                    ? ColorsManager.lightBlueAccent
                    : ColorsManager.darkBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.payment,
                color: ColorsManager.blue,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.tuitionPayments,
                    style: isLight
                        ? AppLightTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    )
                        : AppDarkTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    localizations.tuitionPaymentsDesc,
                    style: isLight
                        ? AppLightTextStyles.bodySmall.copyWith(
                      color: ColorsManager.grayMedium,
                    )
                        : AppDarkTextStyles.bodySmall.copyWith(
                      color: ColorsManager.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: ColorsManager.grayMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class AdvisingSessionCard extends StatelessWidget {
  const AdvisingSessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isLight
                    ? ColorsManager.lightBlueAccent
                    : ColorsManager.darkBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.event_note,
                color: ColorsManager.blue,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.advisingSessions,
                    style: isLight
                        ? AppLightTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    )
                        : AppDarkTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    localizations.advisingSessionsDesc,
                    style: isLight
                        ? AppLightTextStyles.bodySmall.copyWith(
                      color: ColorsManager.grayMedium,
                    )
                        : AppDarkTextStyles.bodySmall.copyWith(
                      color: ColorsManager.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: ColorsManager.grayMedium,
            ),
          ],
        ),
      ),
    );
  }
}