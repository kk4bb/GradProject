import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../../domain/entities/grade_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/grades_cubit.dart';
import '../../cubit/grades_state.dart';
import 'package:bnu_lms_app/shared/di/injection.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import '../../widgets/shared_grades_widgets.dart';

class TaTermWorkScreen extends StatefulWidget {
  final CourseSummaryEntity course;
  final GradeEntity grade;
  final bool isInstructor;

  const TaTermWorkScreen({super.key, required this.course, required this.grade, this.isInstructor = false});

  @override
  State<TaTermWorkScreen> createState() => _TaTermWorkScreenState();
}

class _TaTermWorkScreenState extends State<TaTermWorkScreen> {
  late TextEditingController _projectController;
  late TextEditingController _quizzesController;
  late TextEditingController _assignmentsController;
  late TextEditingController _attendanceController;
  late GradesCubit _gradesCubit;
  bool _isSaving = false;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _gradesCubit = getIt<GradesCubit>();
    _projectController = TextEditingController(text: widget.grade.projectGrade > 0 ? widget.grade.projectGrade.toStringAsFixed(1) : '');
    _quizzesController = TextEditingController(text: widget.grade.quizzesTotal > 0 ? widget.grade.quizzesTotal.toStringAsFixed(1) : '');
    _assignmentsController = TextEditingController(text: widget.grade.assignmentsTotal > 0 ? widget.grade.assignmentsTotal.toStringAsFixed(1) : '');
    _attendanceController = TextEditingController(text: widget.grade.attendanceTotal > 0 ? widget.grade.attendanceTotal.toStringAsFixed(1) : '');
  }

  @override
  void dispose() {
    _projectController.dispose();
    _quizzesController.dispose();
    _assignmentsController.dispose();
    _attendanceController.dispose();
    super.dispose();
  }

  Future<void> _saveTermWork() async {
    if (!_isConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please confirm the grading rubric adherence.')));
      return;
    }
    final project = double.tryParse(_projectController.text) ?? 0.0;
    final quizzes = double.tryParse(_quizzesController.text) ?? 0.0;
    final assignments = double.tryParse(_assignmentsController.text) ?? 0.0;
    final attendance = double.tryParse(_attendanceController.text) ?? 0.0;

    setState(() => _isSaving = true);
    
    final result = await _gradesCubit.repository.updateGrades(
      widget.course.id, 
      widget.grade.studentId, 
      {
        'projectGrade': project,
        'quizzesTotal': quizzes,
        'assignmentsTotal': assignments,
        'attendanceTotal': attendance,
      }
    );

    setState(() => _isSaving = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.toString())));
      },
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Term Work Saved Successfully!')));
        Navigator.pop(context);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return BlocBuilder<GradesCubit, GradesState>(
      bloc: _gradesCubit,
      builder: (context, state) {
        GradeEntity grade = widget.grade;
        if (state is GradesLoaded) {
          if (state.currentStudentGrade != null && state.currentStudentGrade!.studentId == widget.grade.studentId) {
            grade = state.currentStudentGrade!;
          } else {
            final updatedGrade = state.courseGrades.where((g) => g.studentId == widget.grade.studentId).firstOrNull;
            if (updatedGrade != null) grade = updatedGrade;
          }
        }

        return Scaffold(
          backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
          appBar: AppBar(
            title: Text(
              widget.isInstructor ? 'Instructor Override' : 'Academic Clarity', 
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
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
            ],
          ),
          body: IgnorePointer(
            ignoring: !widget.isInstructor && grade.isTermWorkPublished,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                _buildProfileCard(isDarkMode, grade),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Term Work Breakdown',
                      style: TextStyle(
                        color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const PillBadge(text: 'FALL 2024', backgroundColor: ColorsManager.lightBlueAccent, textColor: ColorsManager.blue),
                  ],
                ),
                const SizedBox(height: 16),
                _buildEditableBreakdownItem(isDarkMode, grade, 'Quizzes Total', 'Editable for Bonus', Icons.quiz_outlined, _quizzesController),
                _buildEditableBreakdownItem(isDarkMode, grade, 'Assignments Total', 'Editable for Bonus', Icons.assignment_outlined, _assignmentsController),
                _buildEditableBreakdownItem(isDarkMode, grade, 'Attendance Total', 'Editable for Bonus', Icons.how_to_reg_outlined, _attendanceController),
                const SizedBox(height: 24),
                _buildProjectGradingCard(isDarkMode, grade),
                const SizedBox(height: 24),
                _buildFooterInfo(isDarkMode),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildProfileCard(bool isDarkMode, GradeEntity grade) {
    // Current Weighted Average calculation (approximate for display)
    double totalEarned = grade.quizzesTotal + grade.assignmentsTotal + grade.attendanceTotal + grade.projectGrade + grade.midterm1 + grade.midterm2 + grade.finalExam;
    double maxPossible = 100.0; // Corrected to 100
    double percentage = (totalEarned / maxPossible) * 100;
    if (percentage.isNaN || percentage.isInfinite) percentage = 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9),
                    child: ClipOval(
                      child: grade.studentAvatarUrl != null && grade.studentAvatarUrl!.isNotEmpty
                          ? Image.network(
                              grade.studentAvatarUrl!.startsWith('http')
                                  ? grade.studentAvatarUrl!
                                  : '${ApiConstants.baseUrl.replaceAll('api/', '')}${grade.studentAvatarUrl!.startsWith('/') ? grade.studentAvatarUrl!.substring(1) : grade.studentAvatarUrl!}',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 28),
                            )
                          : const Icon(Icons.person, size: 28),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: ColorsManager.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorsManager.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grade.studentName,
                      style: TextStyle(
                        color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: #${grade.studentId.substring(0, grade.studentId.length > 8 ? 8 : grade.studentId.length).toUpperCase()}',
                      style: TextStyle(
                        color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Weighted Average',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: ColorsManager.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableBreakdownItem(bool isDarkMode, GradeEntity grade, String title, String subtitle, IconData icon, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FBFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              enabled: widget.isInstructor || !grade.isTermWorkPublished,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                color: (!widget.isInstructor && grade.isTermWorkPublished)
                  ? (isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium)
                  : (isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black),
                fontSize: 16, 
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: (!widget.isInstructor && grade.isTermWorkPublished) ? 'Locked' : '0.0',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectGradingCard(bool isDarkMode, GradeEntity grade) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_border, color: ColorsManager.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Project Grading',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Final Project Score (%)',
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _projectController,
                    enabled: widget.isInstructor || !grade.isTermWorkPublished,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      color: (!widget.isInstructor && grade.isTermWorkPublished)
                        ? (isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium)
                        : (isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black),
                      fontSize: 16
                    ),
                    decoration: InputDecoration(
                      hintText: (!widget.isInstructor && grade.isTermWorkPublished) ? 'Locked' : '00',
                      hintStyle: TextStyle(color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'pts',
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Internal Comments',
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              maxLines: 4,
              style: TextStyle(color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter grading notes for professor review...',
                hintStyle: TextStyle(color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isConfirmed,
                  onChanged: (widget.isInstructor || !grade.isTermWorkPublished) ? (val) {
                    setState(() {
                      _isConfirmed = val ?? false;
                    });
                  } : null,
                  activeColor: ColorsManager.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'I confirm that this grade adheres to the institutional grading rubric for Academic Year 2024.',
                  style: TextStyle(
                    color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (!widget.isInstructor && grade.isTermWorkPublished) || _isSaving ? null : _saveTermWork,
              icon: const Text('Submit Term Work', style: TextStyle(fontWeight: FontWeight.bold)),
              label: const Icon(Icons.send, size: 16),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.blue,
                foregroundColor: ColorsManager.white,
                disabledBackgroundColor: isDarkMode ? ColorsManager.darkSurface : ColorsManager.grayMedium,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0C242A) : const Color(0xFFEAF8FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '*Remember to check the plagiarism report before finalizing the project score.*',
        style: TextStyle(
          color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayDark,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
