import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/assets_manager.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../../shared/routes_manager/routes.dart';
import '../../../../../notification/presentation/cubit/notification_cubit.dart';
import '../../../../../notification/presentation/cubit/notification_state.dart';
import '../../../../../../shared/di/injection.dart';

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
          SizedBox(width: 12),
          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                String name = 'Welcome';


                if (state is AuthSuccess) {
                  name = "${state.auth.firstName} ${state.auth.lastName}";

                }

                return Column(
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
                      name,
                      style: isLight
                          ? AppLightTextStyles.labelLarge
                          : AppDarkTextStyles.labelLarge,
                    ),

                  ],
                );
              },
            ),
          ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.notifications);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const ImageIcon(AssetImage(IconsManager.notification)),
                  BlocBuilder<NotificationCubit, NotificationState>(
                    bloc: getIt<NotificationCubit>(),
                    builder: (context, state) {
                      return FutureBuilder<int>(
                        future: getIt<NotificationCubit>().getEnabledUnreadCount(),
                        builder: (context, snapshot) {
                          final unreadCount = snapshot.data ?? 0;
                          if (unreadCount == 0) return const SizedBox.shrink();
                          return Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadCount > 9 ? '9+' : unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ],
    );
  }
}