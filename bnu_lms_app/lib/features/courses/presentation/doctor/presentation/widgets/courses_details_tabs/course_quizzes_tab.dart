import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';



import 'package:bnu_lms_app/features/quizzes/data/models/quiz_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/quiz_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class CourseQuizzesTab extends StatefulWidget {
  final int courseId;
  const CourseQuizzesTab({required this.courseId, super.key});

  @override
  State<CourseQuizzesTab> createState() => _CourseQuizzesTabState();
}

class _CourseQuizzesTabState extends State<CourseQuizzesTab> {
  final QuizRepository _quizRepository = QuizRepository();
  List<Quiz> _quizzes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final quizzes = await _quizRepository.getQuizzes(widget.courseId);
      if (mounted) {
        setState(() {
          _quizzes = quizzes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: ColorsManager.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Create',
                      style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ..._quizzes.map((quiz) => _buildQuizCard(
                context,
                quiz.title,
                'Created N/A', // TODO: Add creation date to model
                'ACTIVE',
                ColorsManager.blue,
                'N/A', // TODO: Add duration to model
                '${quiz.questionCount} Questions',
                'View Results >',
              )),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, String title, String subtitle, String status, Color statusColor, String duration, String questions, String actionText, {IconData? icon}) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: AppLightTextStyles.labelSmall.copyWith(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(subtitle, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: ColorsManager.blue),
              SizedBox(width: 4),
              Text(duration, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
              SizedBox(width: 16),
              Icon(Icons.quiz_outlined, size: 16, color: ColorsManager.blue),
              SizedBox(width: 4),
              Text(questions, style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium),
            ],
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: ColorsManager.grayMedium),
                  SizedBox(width: 4),
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