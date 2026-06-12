import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/di/injection.dart';
import '../../../../courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import '../../../../courses/presentation/cubit/courses_cubit/courses_state.dart';

class ContactAndStats extends StatefulWidget {
  const ContactAndStats({super.key});

  @override
  State<ContactAndStats> createState() => _ContactAndStatsState();
}

class _ContactAndStatsState extends State<ContactAndStats> {
  late final CoursesCubit _coursesCubit;

  @override
  void initState() {
    super.initState();
    _coursesCubit = getIt<CoursesCubit>()..fetchAssignedCourses();
  }

  @override
  void dispose() {
    _coursesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coursesCubit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CoursesCubit, CoursesState>(
            builder: (context, state) {
              String coursesCount = '...';
              if (state is CoursesLoaded) {
                coursesCount = state.courses.length.toString();
              } else if (state is CoursesError) {
                coursesCount = '0';
              }

              return _buildStatBlock(context, coursesCount, 'ASSIGNED COURSES');
            },
          ),
          _buildStatBlock(context, 'N/A', 'STUDENTS'),
          _buildStatBlock(context, 'N/A', 'TASKS'),
        ],
      ),
    );
  }

  Widget _buildStatBlock(BuildContext context, String value, String label) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))] : [],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}