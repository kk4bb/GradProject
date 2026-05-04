import '../../../../../shared/network/token_storage.dart';
import '../../../../../shared/routes_manager/routes.dart';
import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/network/repositories/student_repository.dart';
import '../../data/models/student_profile_model.dart';
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
  final StudentRepository _studentRepository = StudentRepository();
  late Future<StudentProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _studentRepository.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return FutureBuilder<StudentProfile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final profile = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeaderCard(
                  name: profile.fullName,
                  department: profile.faculty,
                  studentId: profile.id.substring(0, 6), // Taking first 6 chars of GUID for display
                  year: profile.academicYear,
                  profileImage: ImagesManager.profileImage,
                ),
                const SizedBox(height: 24.0),
                ProfileStatsGrid(
                  creditHours: profile.creditHours,
                  coursesCount: profile.enrolledCoursesCount,
                ),
                const SizedBox(height: 24.0),
                const PaymentCard(),
                const SizedBox(height: 16.0),
                const AdvisingSessionCard(),
                const SizedBox(height: 24.0),
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
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 24.0),
                ProfileMenuSection(
                  title: 'App',
                  items: [
                    ProfileMenuItem(
                      iconData: Icons.logout,
                      label: 'Log Out',
                      onTap: () async {
                        await tokenStorage.clearAll();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.login,
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        );
      },
    );
  }
}