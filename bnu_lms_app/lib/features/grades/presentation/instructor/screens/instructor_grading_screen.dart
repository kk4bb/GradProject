import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../../domain/entities/grade_entity.dart';
import '../../cubit/grades_cubit.dart';
import 'package:bnu_lms_app/shared/di/injection.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import '../../widgets/shared_grades_widgets.dart';
import '../../ta/screens/ta_term_work_screen.dart';

class InstructorGradingScreen extends StatefulWidget {
  final CourseSummaryEntity course;
  final GradeEntity grade;

  const InstructorGradingScreen({super.key, required this.course, required this.grade});

  @override
  State<InstructorGradingScreen> createState() => _InstructorGradingScreenState();
}

class _InstructorGradingScreenState extends State<InstructorGradingScreen> {
  late TextEditingController _midterm1Controller;
  late TextEditingController _midterm2Controller;
  late TextEditingController _finalExamController;
  late GradesCubit _gradesCubit;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _gradesCubit = getIt<GradesCubit>();
    _midterm1Controller = TextEditingController(text: widget.grade.midterm1 > 0 ? widget.grade.midterm1.toStringAsFixed(1) : '');
    _midterm2Controller = TextEditingController(text: widget.grade.midterm2 > 0 ? widget.grade.midterm2.toStringAsFixed(1) : '');
    _finalExamController = TextEditingController(text: widget.grade.finalExam > 0 ? widget.grade.finalExam.toStringAsFixed(1) : '');

    // Add listeners to update projected grade dynamically if needed
    _midterm1Controller.addListener(() => setState(() {}));
    _midterm2Controller.addListener(() => setState(() {}));
    _finalExamController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _midterm1Controller.dispose();
    _midterm2Controller.dispose();
    _finalExamController.dispose();
    super.dispose();
  }

  Future<void> _saveGrades() async {
    final m1 = double.tryParse(_midterm1Controller.text) ?? 0.0;
    final m2 = double.tryParse(_midterm2Controller.text) ?? 0.0;
    final f = double.tryParse(_finalExamController.text) ?? 0.0;

    if (m1 > 15 || m2 > 15 || f > 40) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scores exceed maximum allowed.')));
      return;
    }

    setState(() => _isSaving = true);
    
    final result = await _gradesCubit.repository.updateGrades(
      widget.course.id, 
      widget.grade.studentId, 
      {
        'midterm1': m1,
        'midterm2': m2,
        'finalExam': f,
      }
    );

    setState(() => _isSaving = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.toString()))),
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grades Saved Successfully!')));
        Navigator.pop(context);
      }
    );
  }

  Future<void> _unlockTermWork(BuildContext context) async {
    setState(() => _isSaving = true);
    // You would add an unlockTermWork method to GradesCubit/Repository.
    // Assuming we've added it:
    final result = await _gradesCubit.repository.unlockTermWork(
      widget.course.id,
    );
    
    setState(() => _isSaving = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.toString()))),
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Term Work Unlocked! TA can edit again.')));
        Navigator.pop(context);
      }
    );
  }

  Future<void> _publishTermWork() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkTheme();
        return AlertDialog(
          backgroundColor: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Publish Term Work?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
          content: Text(
            'Are you sure you want to lock the term work? TAs will no longer be able to edit project grades.',
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
              ),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.blue,
                foregroundColor: ColorsManager.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Publish', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final result = await _gradesCubit.repository.publishTermWork(widget.course.id);
      result.fold(
        (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Term Work published and locked!')));
          Navigator.pop(context); // Go back after publishing
        }
      );
    }
  }

  double _calculateProjectedGrade() {
    final termWorkTotal = widget.grade.quizzesTotal + widget.grade.assignmentsTotal + widget.grade.attendanceTotal + widget.grade.projectGrade;
    final m1 = double.tryParse(_midterm1Controller.text) ?? 0.0;
    final m2 = double.tryParse(_midterm2Controller.text) ?? 0.0;
    final f = double.tryParse(_finalExamController.text) ?? 0.0;
    
    // In actual implementation this maps to whatever max is
    return termWorkTotal + m1 + m2 + f;
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
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();
    final grade = widget.grade;
    
    final termWorkTotal = grade.quizzesTotal + grade.assignmentsTotal + grade.attendanceTotal + grade.projectGrade;
    double projectedScore = _calculateProjectedGrade();
    double currentStandingScore = widget.grade.totalGrade > 0 ? widget.grade.totalGrade : projectedScore;
    
    // Fallbacks if totalGrade is not computed yet in backend
    double projectedPercentage = (projectedScore / 100.0) * 100; // assuming 100 max
    if (projectedPercentage > 100) projectedPercentage = 100;
    
    String standingLetter = _getLetterGrade(currentStandingScore);
    String projectedLetter = _getLetterGrade(projectedScore);

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
        centerTitle: false,
        backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildProfileHeader(isDarkMode, grade),
          const SizedBox(height: 24),
          _buildCurrentStandingCard(isDarkMode, standingLetter, currentStandingScore),
          const SizedBox(height: 24),
          _buildTermWorkCard(context, isDarkMode, termWorkTotal),
          const SizedBox(height: 24),
          _buildExamPerformanceCard(isDarkMode),
          const SizedBox(height: 24),
          _buildProjectedTotalCard(isDarkMode, projectedPercentage, projectedLetter),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (grade.isTermWorkPublished) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : () => _unlockTermWork(context),
                    icon: const Text('Unlock for TA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    label: const Icon(Icons.lock_open, size: 16),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: ColorsManager.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : _saveGrades,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Save Grades',
                        style: TextStyle(
                          color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _publishTermWork,
                      icon: const Text('Publish Grades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      label: const Icon(Icons.send, size: 16),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.blue,
                        foregroundColor: ColorsManager.white,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode, GradeEntity grade) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9),
          child: ClipOval(
            child: grade.studentAvatarUrl != null && grade.studentAvatarUrl!.isNotEmpty
                ? Image.network(
                    grade.studentAvatarUrl!.startsWith('http')
                        ? grade.studentAvatarUrl!
                        : '${ApiConstants.baseUrl.replaceAll('api/', '')}${grade.studentAvatarUrl!.startsWith('/') ? grade.studentAvatarUrl!.substring(1) : grade.studentAvatarUrl!}',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 30),
                  )
                : const Icon(Icons.person, size: 30),
          ),
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${grade.studentId.toUpperCase()}',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                  fontSize: 13,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStandingCard(bool isDarkMode, String letterGrade, double percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0C242A) : const Color(0xFFEAF8FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENT STANDING',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF5A8A9C),
                  fontSize: 11,
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
                    letterGrade,
                    style: const TextStyle(
                      color: ColorsManager.blue,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${percentage.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF94A3B8),
                      fontSize: 14,
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
                'TERM',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF5A8A9C),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Term',
                style: TextStyle(
                  color: isDarkMode ? ColorsManager.darkTextPrimary : const Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermWorkCard(BuildContext context, bool isDarkMode, double total) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaTermWorkScreen(
              course: widget.course,
              grade: widget.grade,
              isInstructor: true,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Term Work',
                  style: TextStyle(
                    color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PillBadge(
                  text: 'LOCKED',
                  backgroundColor: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  textColor: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF94A3B8),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF94A3B8), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Calculated Term Work',
                      style: TextStyle(
                        color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF475569),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        total.toStringAsFixed(1),
                        style: TextStyle(
                          color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' / 30',
                        style: TextStyle(
                          color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamPerformanceCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exam Performance',
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildExamInputField('MIDTERM 1 (15%)', _midterm1Controller, Icons.sort, isDarkMode),
          const SizedBox(height: 20),
          _buildExamInputField('MIDTERM 2 (15%)', _midterm2Controller, Icons.sort, isDarkMode),
          const SizedBox(height: 20),
          _buildExamInputField('FINAL EXAM (40%)', _finalExamController, Icons.star_border, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildExamInputField(String label, TextEditingController controller, IconData icon, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: isDarkMode ? ColorsManager.darkTextSecondary : const Color(0xFF94A3B8), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectedTotalCard(bool isDarkMode, double percentage, String letterGrade) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Always dark
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PROJECTED TOTAL GRADE',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorsManager.blue, width: 2),
                ),
                child: Text(
                  letterGrade,
                  style: const TextStyle(
                    color: ColorsManager.blue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          HorizontalProgressBar(
            current: percentage,
            max: 100.0,
            color: ColorsManager.blue,
            backgroundColor: const Color(0xFF1E293B),
          ),
        ],
      ),
    );
  }
}
