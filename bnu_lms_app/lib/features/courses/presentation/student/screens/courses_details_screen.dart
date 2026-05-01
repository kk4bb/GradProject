import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/network/repositories/attendance_repository.dart';
import '../../../../../shared/network/repositories/course_repository.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../data/models/course_model.dart';
import '../widgets/courses_details/course_description_section.dart';
import '../../shared_widgets/course_header_card.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;
  final String initialTitle;
  final String initialInstructor;
  final IconData icon;

  const CourseDetailsScreen({
    required this.courseId,
    this.initialTitle = 'Loading...',
    this.initialInstructor = '...',
    this.icon = Icons.computer,
    super.key,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CourseRepository _courseRepository = CourseRepository();
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  late Future<CourseDetail> _courseDetailFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _courseDetailFuture = _courseRepository.getCourseDetails(widget.courseId);
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

    return FutureBuilder<CourseDetail>(
      future: _courseDetailFuture,
      builder: (context, snapshot) {
        String title = widget.initialTitle;
        String instructor = widget.initialInstructor;
        
        if (snapshot.hasData) {
          title = snapshot.data!.title;
          instructor = snapshot.data!.instructorName;
        }

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
          ),
          body: Column(
            children: [
              CourseHeaderCard(
                title: title,
                instructor: instructor,
                courseCode: 'COURSE-${widget.courseId}',
                icon: widget.icon,
              ),
              _buildTabBar(isLight),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                        ? Center(child: Text('Error: ${snapshot.error}'))
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildOverviewTab(isLight, snapshot.data!),
                              _buildContentTab(isLight, snapshot.data!),
                              _buildAttendanceTab(isLight),
                            ],
                          ),
              ),
            ],
          ),
        );
      },
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
        labelStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Content'),
          Tab(text: 'Attendance'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isLight, CourseDetail course) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          CourseDescriptionSection(description: course.description),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildContentTab(bool isLight, CourseDetail course) {
    if (course.modules.isEmpty) {
      return const Center(child: Text('No content available yet.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: course.modules.length,
      itemBuilder: (context, index) {
        final module = course.modules[index];
        return ExpansionTile(
          title: Text(module.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          children: module.lessons.map((lesson) {
            return ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: Text(lesson.title),
              subtitle: Text('${lesson.contents.length} items'),
              onTap: () {
                // TODO: Open lesson content
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAttendanceTab(bool isLight) {
    return FutureBuilder<List<AttendanceRecord>>(
      future: _attendanceRepository.getMyAttendance(widget.courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final records = snapshot.data ?? [];
        if (records.isEmpty) {
          return const Center(child: Text('No attendance records found.'));
        }

        final presentCount = records.where((r) => r.isPresent).length;
        final totalCount = records.length;
        final percentage = (presentCount / totalCount * 100).toStringAsFixed(1);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: isLight ? Colors.white : ColorsManager.darkSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total', totalCount.toString(), isLight),
                      _buildStatItem('Present', presentCount.toString(), isLight),
                      _buildStatItem('Percentage', '$percentage%', isLight),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    leading: Icon(
                      record.isPresent ? Icons.check_circle : Icons.cancel,
                      color: record.isPresent ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      'Session ${records.length - index}',
                      style: TextStyle(
                        color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Date: ${record.date.day}/${record.date.month}/${record.date.year}',
                      style: TextStyle(
                        color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                      ),
                    ),
                    trailing: Text(
                      record.isPresent ? 'Present' : 'Absent',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: record.isPresent ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, bool isLight) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorsManager.blue,
          ),
        ),
      ],
    );
  }
}
