import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../l10n/app_localizations.dart';
import '../widget/profile_action_card.dart';
import '../widget/profile_header.dart';
import '../widget/profile_menu_section.dart';
import '../widget/profile_stats.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ProfileHeaderCard(
              name: 'Mohamed',
              department: localizations.computerScience,
              studentId: '123456',
              year: 3,
              profileImage: ImagesManager.profileImage,
            ),
            SizedBox(height: 24.h),
            const ProfileStatsGrid(),
            SizedBox(height: 24.h),
            const PaymentCard(),
            SizedBox(height: 16.h),
            const AdvisingSessionCard(),
            SizedBox(height: 24.h),
            ProfileMenuSection(
              title: localizations.account,
              items: [
                ProfileMenuItem(
                  icon: IconsManager.editProfile,
                  label: localizations.editProfile,
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: IconsManager.password,
                  label: localizations.changePassword,
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ProfileMenuSection(
              title: localizations.support,
              items: [
                ProfileMenuItem(
                  icon: IconsManager.helpCenter,
                  label: localizations.helpCenter,
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: IconsManager.contactSupport,
                  label: localizations.contactSupport,
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}