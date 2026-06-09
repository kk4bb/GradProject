import 'package:bnu_lms_app/features/profile/student/data/models/student_profile_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class CourseStudentsTab extends StatefulWidget {
  final int courseId;
  const CourseStudentsTab({required this.courseId, super.key});

  @override
  State<CourseStudentsTab> createState() => _CourseStudentsTabState();
}

class _CourseStudentsTabState extends State<CourseStudentsTab> {
  final CourseRepository _courseRepository = CourseRepository();
  List<StudentProfile> _students = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final students = await _courseRepository.getEnrolledStudents(widget.courseId);
      if (mounted) {
        setState(() {
          _students = students;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 2),
                  Text(
                    '${_students.length} Students Enrolled',
                    style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkBlue ,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sort, size: 16, color: ColorsManager.blue),
                    const SizedBox(width: 4),
                    Text(
                      'Sort',
                      style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Student List
          ..._students.map((student) => _buildStudentItem(
                context,
                '${student.firstName} ${student.lastName}',
                'ID: ${student.id}',
                'N/A', // TODO: Fetch grade if available
                0.0, // TODO: Fetch attendance if available
                ColorsManager.blue,
              )),
        ],
      ),
    );
  }

  Widget _buildStudentItem(BuildContext context, String name, String id, String grade, double attendance, Color gradeColor) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]
            : [],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: ColorsManager.grayMedium),
              ),
              const SizedBox(width: 12),
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
                padding: const EdgeInsets.all(8),
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
          const SizedBox(height: 16),
          // Attendance Bar
          Row(
            children: [
              Text('ATTENDANCE', style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10)),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: attendance,
                    backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(ColorsManager.blue),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(attendance * 100).toInt()}%', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
            ],
          )
        ],
      ),
    );
  }
}