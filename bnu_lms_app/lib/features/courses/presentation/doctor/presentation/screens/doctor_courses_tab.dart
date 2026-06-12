
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../auth/domain/entities/auth_entity.dart';
import '../../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../home/presentation/doctor/presentation/widgets/doctor_course_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../shared/di/injection.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../cubit/courses_cubit/courses_cubit.dart';
import '../../../cubit/courses_cubit/courses_state.dart';



class DoctorCoursesTab extends StatelessWidget {
  const DoctorCoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CoursesCubit>()..fetchAssignedCourses(),
      child: const _DoctorCoursesTabView(),
    );
  }
}

class _DoctorCoursesTabView extends StatelessWidget {
  const _DoctorCoursesTabView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Text(
              localizations.courses,
              style: isLight
                  ? AppLightTextStyles.headlineLarge
                  : AppDarkTextStyles.headlineLarge,
            ),
          ),
          
          Expanded(
            child: BlocBuilder<CoursesCubit, CoursesState>(
              builder: (context, state) {
                if (state is CoursesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CoursesError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: ColorsManager.red, fontSize: 16),
                    ),
                  );
                } else if (state is CoursesLoaded) {
                  final courses = state.courses;
                  if (courses.isEmpty) {
                    return Center(
                      child: Text(
                        'You are not assigned to any courses.',
                        style: TextStyle(color: ColorsManager.grayDark, fontSize: 16),
                      ),
                    );
                  }

                  return BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      UserRole role = UserRole.unknown;
                      if (authState is AuthSuccess) {
                        role = authState.auth.role;
                      }

                      return ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: courses.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return DoctorCourseCard(
                            academicYear: 'Academic Year 2024/25',
                            courseName: course.title,
                            courseCode: 'SWE-301', // Example course code, API lacks it currently
                            instructorName: course.instructorName,
                            courseIcon: Icons.engineering_outlined,
                            onManageTap: () {
                              final route = role == UserRole.ta ? Routes.taCoursesDetails : Routes.doctorCoursesDetails;
                              Navigator.pushNamed(
                                context, 
                                route,
                                arguments: {
                                  'courseId': course.id,
                                  'courseTitle': course.title,
                                }
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
