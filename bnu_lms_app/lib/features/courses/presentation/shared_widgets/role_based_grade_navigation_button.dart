import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bnu_lms_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import 'package:bnu_lms_app/features/grades/presentation/student/screens/student_course_grades_screen.dart';
import 'package:bnu_lms_app/features/grades/presentation/ta/screens/ta_students_list_screen.dart';
import 'package:bnu_lms_app/features/grades/presentation/instructor/screens/instructor_class_overview_screen.dart';

class RoleBasedGradeNavigationButton extends StatelessWidget {
  final int courseId;
  final String courseTitle;

  const RoleBasedGradeNavigationButton({
    Key? key,
    required this.courseId,
    required this.courseTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final faculty = state.profile.faculty.toLowerCase();
          
          String buttonText = '';
          Color buttonColor = ColorsManager.blue;
          VoidCallback onPressed;

          // Determine role based on faculty or some other logic
          // As per instructions: Student -> My Grades, TA -> Manage Term Work, Instructor -> Course Gradebook
          if (faculty.contains('instructor') || faculty.contains('doctor') || faculty.contains('professor')) {
            buttonText = 'Course Gradebook';
            buttonColor = ColorsManager.blue;
            onPressed = () {
              final courseSummary = CourseSummaryEntity(
                id: courseId,
                title: courseTitle,
                description: '',
                instructorName: '',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InstructorClassOverviewScreen(course: courseSummary),
                ),
              );
            };
          } else if (faculty.contains('ta') || faculty.contains('assistant')) {
            buttonText = 'Manage Term Work';
            buttonColor = const Color(0xFF2FBAD7); // TA cyan
            onPressed = () {
              final courseSummary = CourseSummaryEntity(
                id: courseId,
                title: courseTitle,
                description: '',
                instructorName: '',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaStudentsListScreen(course: courseSummary),
                ),
              );
            };
          } else {
            // Default to Student
            buttonText = 'My Grades';
            buttonColor = ColorsManager.green; // Secondary for student
            onPressed = () {
              final courseSummary = CourseSummaryEntity(
                id: courseId,
                title: courseTitle,
                description: '',
                instructorName: '',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentCourseGradesScreen(course: courseSummary),
                ),
              );
            };
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grade, color: ColorsManager.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: ColorsManager.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
