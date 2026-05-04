import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/network/repositories/quiz_repository.dart';
import '../../../../../../../shared/network/api_service.dart';
import '../../../../../../quizzes/data/models/quiz_model.dart';

class CourseQuizzesTab extends StatefulWidget {
  final int courseId;
  const CourseQuizzesTab({required this.courseId, super.key});

  @override
  State<CourseQuizzesTab> createState() => _CourseQuizzesTabState();
}

class _CourseQuizzesTabState extends State<CourseQuizzesTab> {
  final QuizRepository _quizRepository = QuizRepository();
  late Future<List<Quiz>> _quizzesFuture;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = _quizRepository.getQuizzes(widget.courseId);
  }

  Future<void> _createNewQuiz() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Quiz Title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && titleController.text.isNotEmpty) {
      try {
        await apiService.dio.post(
          'quiz/course/${widget.courseId}',
          data: {
            'title': titleController.text,
            'description': descController.text,
            'dueDate': selectedDate.toIso8601String(),
          },
        );
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz created successfully!')),
        );
        setState(() {
          _quizzesFuture = _quizRepository.getQuizzes(widget.courseId);
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return FutureBuilder<List<Quiz>>(
      future: _quizzesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final quizzes = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Assessments',
                    style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                  ),
                  GestureDetector(
                    onTap: _createNewQuiz,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: ColorsManager.blue,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, color: ColorsManager.white, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(
                            'Create',
                            style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              if (quizzes.isEmpty)
                const Center(child: Text('No quizzes created yet.'))
              else
                ...quizzes.map((quiz) => _buildQuizCard(
                  context,
                  quiz.title,
                  'ID: ${quiz.id}',
                  'ACTIVE',
                  ColorsManager.blue,
                  '--- Mins', 
                  '${quiz.questionCount} Questions',
                  'View Results >'
                )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizCard(BuildContext context, String title, String subtitle, String status, Color statusColor, String duration, String questions, String actionText, {IconData? icon}) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8.0, offset: const Offset(0, 2))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  status,
                  style: AppLightTextStyles.labelSmall.copyWith(color: statusColor, fontSize: 10.0, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(subtitle, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16.0, color: ColorsManager.blue),
              const SizedBox(width: 4.0),
              Text(duration, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
              const SizedBox(width: 16.0),
              const Icon(Icons.quiz_outlined, size: 16.0, color: ColorsManager.blue),
              const SizedBox(width: 4.0),
              Text(questions, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
            ],
          ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14.0, color: ColorsManager.grayMedium),
                  const SizedBox(width: 4.0),
                ],
                Text(
                  actionText,
                  style: AppLightTextStyles.labelMedium.copyWith(color: isLight ? ColorsManager.grayDark : ColorsManager.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
