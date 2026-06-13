import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';

// Import the extracted widgets
import '../widgets/doctor_profile_header.dart';

import '../../../student/presentation/widget/profile_menu_section.dart';
import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/cubit/profile_cubit.dart';
import '../../../presentation/cubit/profile_state.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../../shared/routes_manager/routes.dart';

class DoctorProfileTab extends StatefulWidget {
  const DoctorProfileTab({super.key});

  @override
  State<DoctorProfileTab> createState() => _DoctorProfileTabState();
}

class _DoctorProfileTabState extends State<DoctorProfileTab> {
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
        }
      },
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: Text(
                  'Profile',
                  style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
                ),
              ),
            ),
  
            SizedBox(height: AppSizes.largeSpacing),
  
            // 2. Body
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileError) {
                    return Center(child: Text(state.message));
                  } else if (state is ProfileLoaded) {
                    final profile = state.profile;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Column(
                        children: [
                          DoctorProfileHeader(
                            name: profile.fullName,
                            department: profile.faculty,
                            role: profile.role ?? 'Instructor',
                            profilePictureUrl: profile.profilePictureUrl,
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
                            ],
                          ),
                          SizedBox(height: 20),
                          ProfileMenuSection(
                            title: localizations.support,
                            items: [
                              ProfileMenuItem(
                                icon: IconsManager.theme,
                                label: 'Theme and Language',
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.settings);
                                },
                              ),
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
                          SizedBox(height: 40),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}