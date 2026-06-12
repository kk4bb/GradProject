import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/di/injection.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import '../../../../../courses/presentation/cubit/courses_cubit/courses_state.dart';
import '../../../../../notification/presentation/cubit/notification_cubit.dart';
import '../../../../../notification/presentation/cubit/notification_state.dart';

class DoctorStatsGrid extends StatefulWidget {
  const DoctorStatsGrid({super.key});

  @override
  State<DoctorStatsGrid> createState() => _DoctorStatsGridState();
}

class _DoctorStatsGridState extends State<DoctorStatsGrid> {
  late final CoursesCubit _coursesCubit;

  @override
  void initState() {
    super.initState();
    // Initialize the factory cubit and fetch assigned courses for the doctor
    _coursesCubit = getIt<CoursesCubit>()..fetchAssignedCourses();
    // Fetch notifications on the singleton
    getIt<NotificationCubit>().getNotifications();
  }

  @override
  void dispose() {
    _coursesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _coursesCubit),
        BlocProvider.value(value: getIt<NotificationCubit>()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          final isLight = themeProvider.isLightTheme();

          return Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<CoursesCubit, CoursesState>(
                    builder: (context, state) {
                      String value = '...';
                      if (state is CoursesLoaded) {
                        value = state.courses.length.toString();
                      } else if (state is CoursesInitial || state is CoursesLoading) {
                        value = '...';
                      } else if (state is CoursesError) {
                        value = '0';
                      }

                      return _buildPremiumCard(
                        context: context,
                        isLight: isLight,
                        title: 'Active Courses',
                        value: value,
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFF1E61ED),
                        isLoading: state is CoursesLoading,
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      String value = '...';
                      if (state is NotificationLoaded) {
                        value = state.notifications.where((n) => !n.isRead).length.toString();
                      } else if (state is NotificationEmpty) {
                        value = '0';
                      } else if (state is NotificationInitial || state is NotificationLoading) {
                        value = '...';
                      } else if (state is NotificationError) {
                        value = '0';
                      }

                      return _buildPremiumCard(
                        context: context,
                        isLight: isLight,
                        title: 'New Updates',
                        value: value,
                        icon: Icons.notifications_active,
                        color: const Color(0xFFF25C05),
                        isLoading: state is NotificationLoading,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumCard({
    required BuildContext context,
    required bool isLight,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isLoading,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isLight ? color.withValues(alpha: 0.1) : color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 16),
          if (isLoading)
            SizedBox(
              height: 28,
              width: 28,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              value,
              style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          SizedBox(height: 4),
          Text(
            title,
            style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(
              color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}