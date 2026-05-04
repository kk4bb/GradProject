import 'package:bnu_lms_app/features/quizzes/presentation/widgets/quiz/quiz_item.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/network/repositories/course_repository.dart';
import '../../../../shared/network/repositories/quiz_repository.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../data/models/quiz_model.dart' as model;

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  final QuizRepository _quizRepository = QuizRepository();
  late Future<List<Map<String, dynamic>>> _quizzesFuture;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = _fetchAllQuizzes();
  }

  Future<List<Map<String, dynamic>>> _fetchAllQuizzes() async {
    final courses = await _courseRepository.getEnrolledCourses();
    List<Map<String, dynamic>> allQuizzes = [];

    for (var course in courses) {
      final quizzes = await _quizRepository.getQuizzes(course.id);
      for (var quiz in quizzes) {
        allQuizzes.add({
          'quiz': quiz,
          'courseTitle': course.title,
        });
      }
    }
    return allQuizzes;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.quizzes,
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizzesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final quizzes = snapshot.data!;
          if (quizzes.isEmpty) {
            return const Center(child: Text('No quizzes available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final item = quizzes[index];
              final model.Quiz quiz = item['quiz'];
              final String courseTitle = item['courseTitle'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: QuizItem(
                  title: quiz.title,
                  status: QuizStatus.active,
                  subtitle: courseTitle,
                  date: "Available Now",
                  duration: "--",
                  questionsCount: "${quiz.questionCount} Questions",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.quizDetails,
                      arguments: {'quizId': quiz.id},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}