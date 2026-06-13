import 'package:flutter/material.dart';
import '../../../../../../assignments/presentation/tabs/instructor_assignments_tab.dart';

class CourseAssignmentsTab extends StatelessWidget {
  final int? courseId;

  const CourseAssignmentsTab({super.key, this.courseId});

  @override
  Widget build(BuildContext context) {
    if (courseId == null) return const Center(child: Text("Course ID missing"));
    return InstructorAssignmentsTab(courseId: courseId!);
  }
}