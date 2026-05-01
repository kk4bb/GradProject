import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/network/repositories/course_repository.dart';
import '../../../../../../profile/student/data/models/student_profile_model.dart';

class CourseStudentsTab extends StatefulWidget {
  final int courseId;
  const CourseStudentsTab({required this.courseId, super.key});

  @override
  State<CourseStudentsTab> createState() => _CourseStudentsTabState();
}

class _CourseStudentsTabState extends State<CourseStudentsTab> {
  final CourseRepository _courseRepository = CourseRepository();
  late Future<List<StudentProfile>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _courseRepository.getEnrolledStudents(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return FutureBuilder<List<StudentProfile>>(
      future: _studentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final students = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class Roster',
                        style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        '${students.length} Students Enrolled',
                        style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkBlue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sort, size: 16.0, color: ColorsManager.blue),
                        SizedBox(width: 4.0),
                        Text(
                          'Sort',
                          style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),

              if (students.isEmpty)
                const Center(child: Text('No students enrolled in this course.'))
              else
                ...students.map((student) => _buildStudentItem(
                  context,
                  '${student.firstName} ${student.lastName}',
                  'ID: ${student.id.substring(0, 8)}',
                  'A-', // Placeholder for actual grade if available
                  0.85, // Placeholder for actual attendance if available
                  ColorsManager.blue,
                )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudentItem(BuildContext context, String name, String id, String grade, double attendance, Color gradeColor) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8.0, offset: const Offset(0, 2))]
            : [],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                child: Icon(Icons.person, color: ColorsManager.grayMedium),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                    Text(id, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
                  ],
                ),
              ),
              // Grade Badge
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  grade,
                  style: AppLightTextStyles.labelMedium.copyWith(color: gradeColor, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(height: 16.0),
          // Attendance Bar
          Row(
            children: [
              Text('ATTENDANCE', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10.0)),
              SizedBox(width: 12.0),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: LinearProgressIndicator(
                    value: attendance,
                    backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(ColorsManager.blue),
                    minHeight: 6.0,
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Text('${(attendance * 100).toInt()}%', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
            ],
          )
        ],
      ),
    );
  }
}
