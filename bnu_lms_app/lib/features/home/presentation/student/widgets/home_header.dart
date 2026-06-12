import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/assets_manager.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../../notification/presentation/cubit/notification_cubit.dart';
import '../../../../notification/presentation/cubit/notification_state.dart';
import '../../../../../shared/di/injection.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../../profile/presentation/cubit/profile_state.dart';
import '../../../../../shared/config/api_constants.dart';


class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    return Row(
      children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            bloc: getIt<ProfileCubit>(),
            builder: (context, state) {
              String? profileUrl;
              if (state is ProfileLoaded) {
                profileUrl = state.profile.profilePictureUrl;
              }
              return CircleAvatar(
                radius: 24,
                backgroundColor: ColorsManager.blue,
                child: ClipOval(
                  child: profileUrl != null && profileUrl.isNotEmpty
                      ? Image.network(
                          profileUrl.startsWith('http') 
                              ? profileUrl 
                              : '${ApiConstants.baseUrl.replaceAll('api/', '')}${profileUrl.startsWith('/') ? profileUrl.substring(1) : profileUrl}',
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                          errorBuilder: (context, error, stackTrace) => Image.asset(ImagesManager.profileImage, fit: BoxFit.cover, width: 48, height: 48),
                        )
                      : Image.asset(ImagesManager.profileImage, fit: BoxFit.cover, width: 48, height: 48),
                ),
              );
            },
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CampusConnect',
                  style: isLight
                      ? AppLightTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: ColorsManager.blue,
                        )
                      : AppDarkTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: ColorsManager.blue,
                        ),
                ),
              ],
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
