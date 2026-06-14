import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';

import '../../../domain/entities/quiz_entity.dart';
import '../../screens/edit_quiz_screen.dart';
import '../../screens/quiz_attempts_screen.dart';
import '../../cubit/quiz_list_cubit.dart';

class StudentQuizCard extends StatelessWidget {
  final QuizEntity quiz;
  final String title;
  final String courseTitle;
  final String status;
  final String date;
  final String duration;
  final String questionsCount;
  final String? actionText;
  final bool isInstructor;

  const StudentQuizCard({
    super.key,
    required this.quiz,
    required this.title,
    required this.courseTitle,
    required this.status,
    required this.date,
    required this.duration,
    required this.questionsCount,
    this.actionText,
    this.isInstructor = false,
  });

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);
    
    Color statusColor;
    if (status == 'Live') {
      statusColor = ColorsManager.red;
    } else if (status == 'In Progress') {
      statusColor = ColorsManager.yellow;
    } else if (status == 'Graded') {
      statusColor = ColorsManager.green;
    } else {
      statusColor = ColorsManager.grayMedium;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
        border: Border.all(color: isLight ? Colors.transparent : ColorsManager.grayMedium.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  courseTitle,
                  style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (status == 'Live') ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 4),
                    ],
                    Text(
                      status.toUpperCase(),
                      style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: ColorsManager.grayMedium),
              SizedBox(width: 4),
              Text(date, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: ColorsManager.grayMedium),
              SizedBox(width: 4),
              Text(duration, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium)),
              SizedBox(width: 16),
              Icon(Icons.quiz_outlined, size: 16, color: ColorsManager.grayMedium),
              SizedBox(width: 4),
              Text(questionsCount, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium)),
            ],
          ),
          SizedBox(height: 16),
          if (isInstructor) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(
                        value: context.read<QuizListCubit>(),
                        child: EditQuizScreen(quiz: quiz),
                      )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : ColorsManager.darkBackground,
                      foregroundColor: isLight ? ColorsManager.black : ColorsManager.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Edit Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => QuizAttemptsScreen(quiz: quiz)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26C6DA),
                      foregroundColor: ColorsManager.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('View Attempts', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ] else if (actionText != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (status == 'Live' || status == 'In Progress' || status == 'Available soon' || status == 'READY') {
                    Navigator.pushNamed(context, Routes.quizIntro, arguments: {'quiz': quiz});
                  } else if (status == 'GRADED' || status == 'SUBMITTED') {
                    Navigator.pushNamed(context, Routes.quizResults, arguments: {'quiz': quiz});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (status == 'Live' || status == 'In Progress') ? const Color(0xFF26C6DA) : (isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : ColorsManager.darkBackground),
                  foregroundColor: (status == 'Live' || status == 'In Progress') ? ColorsManager.white : (isLight ? ColorsManager.black : ColorsManager.white),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
