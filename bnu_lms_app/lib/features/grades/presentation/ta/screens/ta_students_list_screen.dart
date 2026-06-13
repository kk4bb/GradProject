import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../../domain/entities/grade_entity.dart';
import '../../cubit/grades_cubit.dart';
import '../../cubit/grades_state.dart';
import 'package:bnu_lms_app/shared/di/injection.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import '../../widgets/shared_grades_widgets.dart';
import 'ta_term_work_screen.dart';

class TaStudentsListScreen extends StatefulWidget {
  final CourseSummaryEntity course;

  const TaStudentsListScreen({super.key, required this.course});

  @override
  State<TaStudentsListScreen> createState() => _TaStudentsListScreenState();
}

class _TaStudentsListScreenState extends State<TaStudentsListScreen> {
  late GradesCubit _gradesCubit;
  String _searchQuery = '';
  String _selectedSection = 'All Students';

  @override
  void initState() {
    super.initState();
    _gradesCubit = getIt<GradesCubit>();
    _gradesCubit.loadCourseGrades(widget.course.id);
  }

  @override
  void dispose() {
    _gradesCubit.close();
    super.dispose();
  }

  void _updateProjectGrade(GradeEntity grade, String value) {
    if (grade.isTermWorkPublished) return;
    final parsed = double.tryParse(value);
    if (parsed != null && parsed >= 0 && parsed <= 5) {
      _gradesCubit.repository.updateGrades(
        widget.course.id,
        grade.studentId,
        {'projectGrade': parsed}
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: TextStyle(color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black),
                decoration: InputDecoration(
                  hintText: 'Search by student name or ID...',
                  hintStyle: TextStyle(color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                  prefixIcon: Icon(Icons.search, color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
              ),
            ),
          ),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip('All Students', isDarkMode),
                const SizedBox(width: 8),
                _buildFilterChip('Section 1', isDarkMode),
                const SizedBox(width: 8),
                _buildFilterChip('Section 2', isDarkMode),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<GradesCubit, GradesState>(
              bloc: _gradesCubit,
              builder: (context, state) {
                if (state is GradesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GradesError) {
                  return Center(child: Text(state.message));
                } else if (state is GradesLoaded) {
                  var students = state.courseGrades;

                  if (_searchQuery.isNotEmpty) {
                    students = students.where((s) => s.studentName.toLowerCase().contains(_searchQuery)).toList();
                  }

                  if (_selectedSection != 'All Students') {
                    students = students.where((s) {
                      String pseudoSection = s.studentId.hashCode % 2 == 0 ? 'Section 1' : 'Section 2';
                      return pseudoSection == _selectedSection;
                    }).toList();
                  }

                  if (students.isEmpty) {
                    return const Center(child: Text('No students found.'));
                  }

                  // bool allPublished = students.isNotEmpty && students.every((s) => s.isTermWorkPublished);

                  return ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final grade = students[index];
                      String section = grade.studentId.hashCode % 2 == 0 ? 'Section 1' : 'Section 2';

                      return _buildStudentCard(grade, section, isDarkMode);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<GradesCubit, GradesState>(
        bloc: _gradesCubit,
        builder: (context, state) {
          bool allPublished = false;
          if (state is GradesLoaded && state.courseGrades.isNotEmpty) {
            allPublished = state.courseGrades.every((s) => s.isTermWorkPublished);
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: allPublished ? null : () {
                  _gradesCubit.repository.publishTermWork(widget.course.id).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Term Work Submitted!')));
                    _gradesCubit.loadCourseGrades(widget.course.id);
                  });
                },
                icon: const Text('Submit Term Work', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                label: const Icon(Icons.send, size: 18),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? ColorsManager.blue : ColorsManager.blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isDarkMode ? ColorsManager.darkSurface : ColorsManager.grayMedium,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isDarkMode) {
    bool isSelected = _selectedSection == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSection = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? ColorsManager.blue
              : (isDarkMode ? ColorsManager.darkSurface : ColorsManager.white),
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFF1F5F9)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(GradeEntity grade, String section, bool isDarkMode) {
    TextEditingController controller = TextEditingController(text: grade.projectGrade > 0 ? grade.projectGrade.toInt().toString() : '');
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaTermWorkScreen(course: widget.course, grade: grade),
          ),
        ).then((_) => _gradesCubit.loadCourseGrades(widget.course.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                PillBadge(
                  text: section,
                  backgroundColor: ColorsManager.lightBlueAccent,
                  textColor: ColorsManager.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScoreColumn('Quizzes', grade.quizzesTotal, isDarkMode),
                Container(width: 1, height: 30, color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9)),
                _buildScoreColumn('Assignments', grade.assignmentsTotal, isDarkMode),
                Container(width: 1, height: 30, color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9)),
                _buildScoreColumn('Attendance', grade.attendanceTotal, isDarkMode),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Project Grade (Editable)',
              style: TextStyle(
                color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF8FBFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: grade.projectGrade == 0 ? ColorsManager.red.withValues(alpha: 0.3) : Colors.transparent,
                ),
              ),
              child: IgnorePointer(
                ignoring: grade.isTermWorkPublished,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        enabled: !grade.isTermWorkPublished,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(
                          color: grade.isTermWorkPublished 
                            ? (isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium)
                            : (isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: grade.isTermWorkPublished ? 'Locked' : 'Enter grade',
                          hintStyle: TextStyle(color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onSubmitted: (val) => _updateProjectGrade(grade, val),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreColumn(String label, double current, bool isDarkMode) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${current.toStringAsFixed(1)} pts',
          style: TextStyle(
            color: isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
