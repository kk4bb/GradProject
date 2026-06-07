import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../widgets/courses_details/assignment_item_card.dart';
import '../widgets/courses_details/course_description_section.dart';
import '../../shared_widgets/course_header_card.dart';
import '../widgets/courses_details/learning_outcomes_section.dart';
import '../widgets/courses_details/upcoming_event_card.dart';


class CourseDetailsScreen extends StatefulWidget {
  final String courseTitle;
  final String instructor;
  final String courseCode;
  final IconData icon;

  const CourseDetailsScreen({
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

  final List<Map<String, dynamic>> assignments = [
    {
      'title': 'Project Phase 1',
      'dueDate': 'Nov 20, 2024',
      'status': 'Pending',
      'statusColor': Colors.orange,
    },
    {
      'title': 'Design Pattern Report',
      'dueDate': 'Nov 15, 2024',
      'status': 'Submitted',
      'statusColor': ColorsManager.green,
    },
    {
      'title': 'Midterm Exam',
      'dueDate': 'Nov 10, 2024',
      'status': 'Completed',
      'statusColor': ColorsManager.blue,
    },
  ];

  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'title': 'Midterm Exam Schedule',
      'description':
      'The midterm exam has been scheduled for Nov 15th. Please check the \'Assignments\' tab for more details.',
      'date': 'Nov 1, 2023',
      'icon': Icons.event_note,
    },
    {
      'title': 'Project Proposal Submissions',
      'description':
      'The deadline for project proposal submission is approaching. Please submit your documents before Oct 28th.',
      'date': 'Oct 22, 2023',
      'icon': Icons.assignment_turned_in,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          CourseHeaderCard(
            title: widget.courseTitle,
            instructor: widget.instructor,
            courseCode: widget.courseCode,
            icon: widget.icon,
          ),
          _buildTabBar(isLight),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(isLight),
                _buildAssignmentsTab(isLight),
                _buildUpcomingTab(isLight),
              ],
            ),
          ),
        ],
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
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Assignments'),
          Tab(text: 'Upcoming'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isLight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          CourseDescriptionSection(description: courseDescription),
          SizedBox(height: 32.h),
          LearningOutcomesSection(outcomes: learningOutcomes),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildAssignmentsTab(bool isLight) {
    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'All Assignments',
              style: isLight
                  ? AppLightTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              )
                  : AppDarkTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ...assignments.map((assignment) {
              return AssignmentItemCard(
                title: assignment['title'],
                dueDate: assignment['dueDate'],
                status: assignment['status'],
                statusColor: assignment['statusColor'],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTab(bool isLight) {
    return SingleChildScrollView(
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'Recent Announcements',
              style: isLight
                  ? AppLightTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              )
                  : AppDarkTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ...upcomingEvents.map((event) {
              return UpcomingEventCard(
                title: event['title'],
                date: event['date'],
                description: event['description'],
                icon: event['icon'],
              );
            }),
          ],
        ),
      ),
    );
  }
}
