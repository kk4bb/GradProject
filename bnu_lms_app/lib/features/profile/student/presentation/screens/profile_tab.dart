import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../presentation/cubit/profile_cubit.dart';
import '../../../presentation/cubit/profile_state.dart';

import '../widget/profile_header.dart';
import '../widget/profile_menu_section.dart';
import '../widget/profile_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../shared/routes_manager/routes.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    // Fetch profile once when the tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeaderCard(
                      name: profile.fullName,
                      department: profile.faculty,
                      studentId: profile.studentId ?? 'N/A', 
                      year: profile.academicYear,
                      profileImage: ImagesManager.profileImage,
                      profilePictureUrl: profile.profilePictureUrl,
                    ),
                    SizedBox(height: 24),
                    ProfileStatsGrid(
                      gpa: profile.gpa?.toString() ?? 'N/A',
                      credits: profile.creditHours.toString(),
                      rank: profile.rank?.toString() ?? 'N/A',
                    ), 
                    SizedBox(height: 24),
                    ProfileMenuSection(
                      title: localizations.account,
                      items: [
                        ProfileMenuItem(
                          icon: IconsManager.editProfile,
                          label: localizations.editProfile,
                          onTap: () {
                            Navigator.pushNamed(context, Routes.editProfile);
                          },
                        ),
                        ProfileMenuItem(
                          icon: IconsManager.password,
                          label: localizations.changePassword,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: IconsManager.theme,
                          label: 'Theme and Language',
                          onTap: () {
                            Navigator.pushNamed(context, Routes.settings);
                          },
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
                          onTap: () {
                            Navigator.pushNamed(context, Routes.helpCenter);
                          },
                        ),
                        ProfileMenuItem(
                          icon: IconsManager.warning, 
                          label: 'Log Out',
                          onTap: () async {
                            await context.read<AuthCubit>().logout();
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
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}