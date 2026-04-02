import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/app_sizes.dart';
import 'quick_action_card.dart';

class DoctorQuickAccessSection extends StatelessWidget {
  const DoctorQuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 30),
          child: Text(
            localizations.quickAccess,
            style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
          ),
        ),
        SizedBox(height: AppSizes.mediumSpacing),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuickActionCard(
                  icon: Icons.how_to_reg_outlined,
                  label: 'Take Attendance',
                  onTap: () {},
                ),
                SizedBox(width: 16.w),
                QuickActionCard(
                  icon: Icons.assignment_add,
                  label: 'Create Assignment',
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuickActionCard(
                  icon: Icons.quiz_outlined,
                  label: 'Create Quiz',
                  onTap: () {},
                ),
                SizedBox(width: 16.w),
                QuickActionCard(
                  icon: Icons.campaign_outlined,
                  label: 'Post Update',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}