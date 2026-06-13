import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/auth/domain/entities/auth_entity.dart';
import 'package:bnu_lms_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bnu_lms_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:bnu_lms_app/features/forums/presentation/doctor/presentation/screens/doctor_forums_details_screen.dart';
import 'package:bnu_lms_app/features/forums/presentation/ta/presentation/screens/ta_forums_details_screen.dart';

import '../../../../../../shared/di/injection.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../data/forums_data.dart';
import '../../../../../../../features/courses/domain/entities/course_entity.dart';
import '../../../../../../../features/courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import '../../../../../../../features/courses/presentation/cubit/courses_cubit/courses_state.dart';
import '../widgets/fourms/forum_card.dart';
import '../widgets/fourms/forum_search.dart';
import 'forums_details_screen.dart';

class ForumsTab extends StatelessWidget {
  const ForumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine which fetch method to call based on role
    final authState = context.read<AuthCubit>().state;
    UserRole role = UserRole.unknown;
    if (authState is AuthSuccess) role = authState.auth.role;

    return BlocProvider(
      create: (_) {
        final cubit = getIt<CoursesCubit>();
        if (role == UserRole.instructor || role == UserRole.ta) {
          cubit.fetchAssignedCourses();
        } else {
          cubit.fetchEnrolledCourses();
        }
        return cubit;
      },
      child: _ForumsTabBody(role: role),
    );
  }
}

class _ForumsTabBody extends StatefulWidget {
  final UserRole role;
  const _ForumsTabBody({required this.role});

  @override
  State<_ForumsTabBody> createState() => _ForumsTabBodyState();
}

class _ForumsTabBodyState extends State<_ForumsTabBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _routeToForumDetails(BuildContext context, CourseSummaryEntity course) {
    Widget screen;
    if (widget.role == UserRole.instructor) {
      screen = DoctorForumsDetailsScreen(courseName: course.title, courseId: course.id);
    } else if (widget.role == UserRole.ta) {
      screen = TaForumsDetailsScreen(courseName: course.title, courseId: course.id);
    } else {
      screen = ForumsDetailsScreen(forumTitle: course.title, courseId: course.id);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        title: Text(
          localization.forums,
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      ),
      body: Column(
        children: [
          Container(
            color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
            child: ForumSearch(_searchController, () => setState(() {})),
          ),
          Expanded(
            child: BlocBuilder<CoursesCubit, CoursesState>(
              builder: (context, state) {
                if (state is CoursesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CoursesError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: ColorsManager.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (state is CoursesLoaded) {
                  final courses = _query.isEmpty
                      ? state.courses
                      : state.courses
                          .where((c) => c.title.toLowerCase().contains(_query))
                          .toList();

                  if (courses.isEmpty) {
                    return Center(
                      child: Text(
                        _query.isEmpty ? 'No courses found.' : 'No forums match "$_query".',
                        style: TextStyle(
                          color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Courses', isLight),
                        ...courses.map(
                          (course) => GestureDetector(
                            onTap: () => _routeToForumDetails(context, course),
                            child: AbsorbPointer(
                              child: ForumCard(
                                forum: ForumsData(
                                  title: course.title,
                                  description: course.instructorName,
                                  image: 'assets/images/programming.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isLight) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: isLight
            ? AppLightTextStyles.labelLarge.copyWith(
                color: ColorsManager.black,
                fontWeight: FontWeight.bold,
              )
            : AppDarkTextStyles.labelLarge.copyWith(
                color: ColorsManager.darkTextPrimary,
                fontWeight: FontWeight.bold,
              ),
      ),
    );
  }
}
