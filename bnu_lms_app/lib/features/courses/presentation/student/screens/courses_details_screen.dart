import 'package:bnu_lms_app/features/courses/presentation/student/widgets/courses_details/student_course_quizzes_tab.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../assignments/presentation/tabs/student_assignments_tab.dart';
import '../widgets/courses_details/course_description_section.dart';
import '../widgets/courses_details/student_materials_tab.dart';
import '../../shared_widgets/course_header_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/di/injection.dart';
import '../../cubit/course_details_cubit/course_details_cubit.dart';
import '../../cubit/course_details_cubit/course_details_state.dart';
import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../../../../features/quizzes/presentation/cubit/quiz_list_cubit.dart';



class CourseDetailsScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  final String instructor;
  final String courseCode;
  final IconData icon;

  const CourseDetailsScreen({
    required this.courseId,
    required this.courseTitle,
    required this.instructor,
    this.courseCode = 'SWE-301',
    this.icon = Icons.computer,
    super.key,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Static data for demonstration
  final String courseDescription =
      'This course covers advanced concepts in software engineering, focusing on design patterns, agile methodologies, and large-scale system architecture. Students will gain hands-on experience through a semester-long project.';

  final List<String> learningOutcomes = [
    'Analyze complex software requirements.',
    'Apply various design patterns to solve problems.',
    'Implement and test large-scale software systems.',
  ];




  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight
          ? ColorsManager.lightBackground
          : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Course Details',
          style: isLight
              ? AppLightTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          )
              : AppDarkTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: BlocProvider(
        create: (context) => getIt<CourseDetailsCubit>()..fetchCourseDetails(widget.courseId),
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
                  CourseHeaderCard(
                    title: course.title,
                    instructor: course.instructorName,
                    courseCode: widget.courseCode,
                    icon: widget.icon,
                  ),

                  _buildTabBar(isLight),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(isLight, course),
                        const StudentMaterialsTab(),
                        StudentAssignmentsTab(courseId: course.id),
                        BlocProvider(
                          create: (_) => getIt<QuizListCubit>(),
                          child: StudentCourseQuizzesTab(courseId: course.id),
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
    );
  }

  Widget _buildTabBar(bool isLight) {
    return Container(
      color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      child: TabBar(
        controller: _tabController,
        labelColor: ColorsManager.blue,
        dividerColor: Colors.transparent,
        unselectedLabelColor: isLight
            ? ColorsManager.grayMedium
            : ColorsManager.darkTextSecondary,
        indicatorColor: ColorsManager.blue,
        indicatorWeight: 2,
        labelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Materials'),
          Tab(text: 'Assignments'),
          Tab(text: 'Quizzes'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isLight, CourseDetailEntity course) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          CourseDescriptionSection(description: course.description.isEmpty ? courseDescription : course.description),
          SizedBox(height: 32),
        ],
      ),
    );
  }



}
