import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/di/injection.dart';

// Shared Widgets
import '../../../../../assignments/presentation/manager/instructor/assignments_cubit.dart';
import '../../../../../quizzes/presentation/cubit/quiz_list_cubit.dart';
import '../../../shared_widgets/course_header_card.dart';



// Reused Doctor Tabs (Clean Architecture)
import '../../../doctor/presentation/widgets/courses_details_tabs/course_students_tab.dart';
import '../../../doctor/presentation/widgets/courses_details_tabs/course_quizzes_tab.dart';
import '../../../doctor/presentation/widgets/courses_details_tabs/course_materials_tab.dart';
import '../../../doctor/presentation/widgets/courses_details_tabs/course_attendance_tab.dart';

// The New Assignments Tab
import '../widgets/course_details/ta_course_assignments_tab.dart';

import '../../../cubit/course_details_cubit/course_details_cubit.dart';
import '../../../cubit/course_details_cubit/course_details_state.dart';
import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';

class TaCourseDetailsScreen extends StatelessWidget {
  final int courseId;
  final String courseTitle;

  const TaCourseDetailsScreen({
    required this.courseId,
    required this.courseTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isLight ? ColorsManager.black : ColorsManager.white,
              size: 20,
            ),
          ),
          title: Text(
            'Course Details',
            style: isLight
                ? AppLightTextStyles.headlineLarge
                : AppDarkTextStyles.headlineLarge,
          ),
          actions: [],
        ),
        body: BlocProvider(
          create: (context) => getIt<CourseDetailsCubit>()..fetchCourseDetails(courseId),
          child: BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
            builder: (context, state) {
              if (state is CourseDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CourseDetailsError) {
                return Center(child: Text(state.message, style: TextStyle(color: ColorsManager.red)));
              } else if (state is CourseDetailsLoaded || state is CourseActionLoading || state is CourseActionError) {
                
                CourseDetailEntity? course;
                if (state is CourseDetailsLoaded) course = state.course;
                if (state is CourseActionLoading) course = state.course;
                if (state is CourseActionError) course = state.course;

                if (course == null) return const SizedBox();

                return Column(
                  children: [
                    // 1. The Header Banner (Fixed at Top)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: CourseHeaderCard(
                        title: course.title,
                        courseCode: 'SWE-301',
                        instructor: course.instructorName,
                        icon: Icons.code,
                      ),
                    ),


                    // 2. The Tab Bar
                    TabBar(
                      isScrollable: true,
                      indicatorColor: const Color(0xFF2FBAD7), // TA Cyan
                      indicatorWeight: 3,
                      labelColor: const Color(0xFF2FBAD7),
                      unselectedLabelColor: ColorsManager.grayMedium,
                      labelStyle: AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                      unselectedLabelStyle: AppLightTextStyles.titleMedium.copyWith(fontSize: 14),
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      tabs: const [
                        Tab(text: 'Students'),
                        Tab(text: 'Materials'),
                        Tab(text: 'Attendance'),
                        Tab(text: 'Assignments'), // Custom TA Version
                        Tab(text: 'Quizzes'),
                      ],
                    ),

                    // 3. The Tab Content
                    Expanded(
                      child: TabBarView(
                        children: [
                          // 1. Students (Reused)
                          CourseStudentsTab(courseId: course.id),

                          // 2. Materials (Reused)
                          const CourseMaterialsTab(),

                          // 3. Attendance (Reused)
                          CourseAttendanceTab(courseId: course.id),

                          // 4. Assignments (Custom TA Version with Grading Actions)
                          BlocProvider(
                            create: (context) => getIt<AssignmentsCubit>()..getAssignments(course!.id),
                            child: TaCourseAssignmentsTab(courseId: course.id),
                          ),

                          // 5. Quizzes (Reused)
                          BlocProvider(
                            create: (_) => getIt<QuizListCubit>()..loadQuizzes(course!.id),
                            child: CourseQuizzesTab(courseId: course.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),

        // Optional: TA might not have a general "Add" FAB, usually contextual
      ),
    );
  }
}