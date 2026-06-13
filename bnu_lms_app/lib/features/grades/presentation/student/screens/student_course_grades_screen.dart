import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../cubit/grades_cubit.dart';
import '../../cubit/grades_state.dart';
import 'package:bnu_lms_app/shared/di/injection.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bnu_lms_app/features/profile/presentation/cubit/profile_state.dart';
import '../../widgets/shared_grades_widgets.dart';

class StudentCourseGradesScreen extends StatefulWidget {
  final CourseSummaryEntity course;

  const StudentCourseGradesScreen({super.key, required this.course});

  @override
  State<StudentCourseGradesScreen> createState() => _StudentCourseGradesScreenState();
}

class _StudentCourseGradesScreenState extends State<StudentCourseGradesScreen> {
  late GradesCubit _gradesCubit;
  late String _studentId;

  @override
  void initState() {
    super.initState();
    _gradesCubit = getIt<GradesCubit>();
    
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      _studentId = profileState.profile.id;
    } else {
      _studentId = 'mock_student_id';
    }
    
    _gradesCubit.loadStudentGrades(widget.course.id, _studentId);
  }

  @override
  void dispose() {
    _gradesCubit.close();
    super.dispose();
  }

  String _getLetterGrade(double score) {
    if (score >= 90) return 'A';
    if (score >= 85) return 'A-';
    if (score >= 80) return 'B+';
    if (score >= 75) return 'B';
    if (score >= 70) return 'B-';
    if (score >= 65) return 'C+';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return Scaffold(
      backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
      appBar: AppBar(
        title: Text(
          'Academic Clarity', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          )
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<GradesCubit, GradesState>(
        bloc: _gradesCubit,
        builder: (context, state) {
          if (state is GradesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GradesError) {
            return Center(child: Text(state.message));
          } else if (state is GradesLoaded) {
            final grade = state.currentStudentGrade;
            if (grade == null) {
              return const Center(child: Text('No grades available.'));
            }

            final termWorkTotal = grade.quizzesTotal + grade.assignmentsTotal + grade.attendanceTotal + grade.projectGrade;
            final letterGrade = _getLetterGrade(grade.totalGrade);

            return RefreshIndicator(
              onRefresh: () async {
                _gradesCubit.loadStudentGrades(widget.course.id, _studentId);
              },
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  _buildHeader(isDarkMode),
                  const SizedBox(height: 24),
                  _buildTotalPerformanceCard(isDarkMode, grade.totalGrade, letterGrade),
                  const SizedBox(height: 24),
                  Text(
                    'DETAILED BREAKDOWN',
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTermWorkCard(isDarkMode, grade, termWorkTotal),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildExamCard(isDarkMode, 'EXAM 01', 'Midterm 1', grade.midterm1, 15.0)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildExamCard(isDarkMode, 'EXAM 02', 'Midterm 2', grade.midterm2, 15.0)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFinalExamCard(isDarkMode, grade.finalExam, 40.0),
                  const SizedBox(height: 24),
                  _buildInstructorFeedback(isDarkMode),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.arrow_back_ios, size: 10, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
            const SizedBox(width: 4),
            Text(
              'BACK TO COURSES',
              style: TextStyle(
                color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.course.title,
          style: TextStyle(
            color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Professor ${widget.course.instructorName}',
          style: TextStyle(
            color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPerformanceCard(bool isDarkMode, double totalGrade, String letterGrade) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL PERFORMANCE',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${totalGrade.toInt()}',
                    style: TextStyle(
                      color: ColorsManager.blue,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' /100',
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Grade: $letterGrade',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTermWorkCard(bool isDarkMode, dynamic grade, double termWorkTotal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 20, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                  const SizedBox(width: 8),
                  Text(
                    'Term Work',
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${termWorkTotal.toStringAsFixed(1)} / 30', // Max 30
                style: const TextStyle(
                  color: ColorsManager.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildBreakdownRow('Quizzes', grade.quizzesTotal, 10.0, isDarkMode),
          const SizedBox(height: 20),
          _buildBreakdownRow('Assignments', grade.assignmentsTotal, 10.0, isDarkMode),
          const SizedBox(height: 20),
          _buildBreakdownRow('Attendance', grade.attendanceTotal, 5.0, isDarkMode),
          const SizedBox(height: 20),
          _buildBreakdownRow('Project', grade.projectGrade, 5.0, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, double current, double max, bool isDarkMode) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: HorizontalProgressBar(
            current: current,
            max: max,
            color: ColorsManager.blue,
            backgroundColor: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 45,
          child: Text(
            '${current.toInt()}/${max.toInt()}',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamCard(bool isDarkMode, String label, String title, double current, double max) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${current.toInt()}',
                style: TextStyle(
                  color: ColorsManager.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' /${max.toInt()}',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalExamCard(bool isDarkMode, double current, double max) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark aesthetic
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CONSOLIDATED ASSESSMENT',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Final Exam',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${current.toInt()}',
                    style: const TextStyle(
                      color: ColorsManager.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' /${max.toInt()}',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'WEIGHT: 40%',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorFeedback(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0C242A) : const Color(0xFFEAF8FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 16, color: ColorsManager.blue),
              const SizedBox(width: 8),
              const Text(
                'INSTRUCTOR FEEDBACK',
                style: TextStyle(
                  color: ColorsManager.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'No feedback provided yet.',
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
