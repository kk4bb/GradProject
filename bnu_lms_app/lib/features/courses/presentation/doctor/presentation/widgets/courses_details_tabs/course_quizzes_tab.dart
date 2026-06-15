import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../quizzes/presentation/cubit/quiz_list_cubit.dart';
import '../../../../../../quizzes/presentation/student/widgets/student_quiz_card.dart';
import 'package:intl/intl.dart';

class CourseQuizzesTab extends StatefulWidget {
  final int courseId;
  const CourseQuizzesTab({super.key, required this.courseId});

  @override
  State<CourseQuizzesTab> createState() => _CourseQuizzesTabState();
}

class _CourseQuizzesTabState extends State<CourseQuizzesTab> {
  @override
  @override
  void initState() {
    super.initState();
    context.read<QuizListCubit>().loadQuizzes(widget.courseId);
    context.read<QuizListCubit>().listenToRealTimeUpdates(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return BlocBuilder<QuizListCubit, QuizListState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Assessments',
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
              ),
              SizedBox(height: 20),
              if (state is QuizListLoading)
                const Center(child: CircularProgressIndicator(color: Color(0xFF26C6DA)))
              else if (state is QuizListError)
                Center(child: Text(state.message, style: const TextStyle(color: ColorsManager.red)))
              else if (state is QuizListLoaded)
                if (state.quizzes.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text('No quizzes created yet.', style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium),
                    ),
                  )
                else
                  ...state.quizzes.map((quiz) => StudentQuizCard(
                        quiz: quiz,
                        title: quiz.title,
                        courseTitle: quiz.description,
                        status: quiz.areGradesPublished ? 'PUBLISHED' : 'DRAFT',
                        date: DateFormat('dd/MM/yyyy hh:mm a').format(quiz.startDate.toLocal()),
                        duration: '${quiz.durationMinutes} Mins',
                        questionsCount: '${quiz.questionCount} Questions',
                        actionText: 'Manage Settings >',
                        isInstructor: true,
                      )),
            ],
          ),
        );
      },
    );
  }


}