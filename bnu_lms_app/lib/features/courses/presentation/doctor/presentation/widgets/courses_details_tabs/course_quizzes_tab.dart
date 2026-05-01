import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/network/repositories/quiz_repository.dart';
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
          padding: EdgeInsets.all(20.0),
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
                    onTap: () {
                      // TODO: Implement Create Quiz flow
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: ColorsManager.blue,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: ColorsManager.white, size: 16.0),
                          SizedBox(width: 4.0),
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
              SizedBox(height: 20.0),

              if (quizzes.isEmpty)
                const Center(child: Text('No quizzes created yet.'))
              else
                ...quizzes.map((quiz) => _buildQuizCard(
                  context,
                  quiz.title,
                  'ID: ${quiz.id}',
                  'ACTIVE',
                  ColorsManager.blue,
                  '--- Mins', // Backend Quiz model doesn't have duration
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
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
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
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
          SizedBox(height: 4.0),
          Text(subtitle, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
          SizedBox(height: 16.0),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16.0, color: ColorsManager.blue),
              SizedBox(width: 4.0),
              Text(duration, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
              SizedBox(width: 16.0),
              Icon(Icons.quiz_outlined, size: 16.0, color: ColorsManager.blue),
              SizedBox(width: 4.0),
              Text(questions, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
            ],
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14.0, color: ColorsManager.grayMedium),
                  SizedBox(width: 4.0),
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