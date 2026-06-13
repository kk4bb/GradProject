import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../cubit/grades_cubit.dart';
import '../../cubit/grades_state.dart';
import 'package:bnu_lms_app/shared/di/injection.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import 'package:provider/provider.dart';
import 'instructor_grading_screen.dart';

class InstructorClassOverviewScreen extends StatefulWidget {
  final CourseSummaryEntity course;

  const InstructorClassOverviewScreen({super.key, required this.course});

  @override
  State<InstructorClassOverviewScreen> createState() => _InstructorClassOverviewScreenState();
}

class _InstructorClassOverviewScreenState extends State<InstructorClassOverviewScreen> {
  late GradesCubit _gradesCubit;

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
          _gradesCubit.loadCourseGrades(widget.course.id);
        }
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
          '${widget.course.title} - Overview', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<GradesCubit, GradesState>(
        bloc: _gradesCubit,
        builder: (context, state) {
          if (state is GradesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GradesError) {
            return Center(child: Text(state.message));
          } else if (state is GradesLoaded) {
            final students = state.courseGrades;
            if (students.isEmpty) {
              return const Center(child: Text('No students found.'));
            }

            final classAverage = students.fold<double>(0, (sum, item) => sum + item.totalGrade) / students.length;
            final fullyGraded = students.where((s) => s.totalGrade >= 0).length; // Adjust logic as needed

              return Column(
                children: [
                  // Top Statistics Row
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Class Average',
                            value: '${classAverage.toStringAsFixed(1)} / 100',
                            icon: Icons.analytics,
                            color: ColorsManager.blue,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Graded',
                            value: '$fullyGraded / ${students.length}',
                            icon: Icons.check_circle,
                            color: ColorsManager.green,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _publishTermWork,
                        icon: const Icon(Icons.publish),
                        label: const Text('Publish All Term Work', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  ),
                  const SizedBox(height: 20),

                  // List of Students
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final grade = students[index];
                        final isReady = grade.isTermWorkPublished;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFE5E7EB)),
                            boxShadow: isDarkMode ? null : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: isDarkMode ? ColorsManager.darkBackground : const Color(0xFFF1F5F9),
                              child: ClipOval(
                                child: grade.studentAvatarUrl != null && grade.studentAvatarUrl!.isNotEmpty
                                    ? Image.network(
                                        grade.studentAvatarUrl!.startsWith('http')
                                            ? grade.studentAvatarUrl!
                                            : '${ApiConstants.baseUrl.replaceAll('api/', '')}${grade.studentAvatarUrl!.startsWith('/') ? grade.studentAvatarUrl!.substring(1) : grade.studentAvatarUrl!}',
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.person, color: ColorsManager.blue),
                                      )
                                    : Icon(Icons.person, color: ColorsManager.blue),
                              ),
                            ),
                            title: Text(
                              grade.studentName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Total: ${grade.totalGrade.toStringAsFixed(1)} / 100',
                                style: TextStyle(
                                  color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
                                ),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isReady ? ColorsManager.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isReady ? 'Ready' : 'In Progress',
                                style: TextStyle(
                                  color: isReady ? ColorsManager.green : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InstructorGradingScreen(course: widget.course, grade: grade),
                                ),
                              ).then((_) => _gradesCubit.loadCourseGrades(widget.course.id));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  final bool isDarkMode;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? ColorsManager.darkSurface : const Color(0xFFE5E7EB)),
        boxShadow: isDarkMode ? null : [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? ColorsManager.darkTextSecondary : ColorsManager.grayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
