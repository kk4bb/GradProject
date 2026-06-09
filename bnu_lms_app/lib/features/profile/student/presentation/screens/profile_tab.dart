import 'package:bnu_lms_app/features/profile/student/data/models/student_profile_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/student_repository.dart';
import 'package:bnu_lms_app/shared/network/token_storage.dart';
import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:flutter/material.dart';
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
  final StudentRepository _studentRepository = StudentRepository();
  StudentProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _studentRepository.getProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profile == null) {
      return Center(child: Text("Failed to load profile"));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ProfileHeaderCard(
              name: _profile!.fullName,
              department: _profile!.faculty,
              studentId: _profile!.id,
              year: _profile!.academicYear,
              profileImage: ImagesManager.profileImage,
            ),
            SizedBox(height: 24),
            const ProfileStatsGrid(),
            SizedBox(height: 24),
            const PaymentCard(),
            SizedBox(height: 16),
            const AdvisingSessionCard(),
            SizedBox(height: 24),
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
            SizedBox(height: 20),
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
                ProfileMenuItem(
                  icon: Icons.logout, // Use Icons.logout instead of an asset image
                  label: 'Log out',
                  onTap: () async {
                    await tokenStorage.clearAll();
                    if(mounted) {
                      Navigator.pushReplacementNamed(context, '/login'); 
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}