import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_list_cubit.dart';

import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';

import '../student/widgets/student_quiz_card.dart';

class StudentQuizDashboardScreen extends StatefulWidget {
  const StudentQuizDashboardScreen({super.key});

  @override
  State<StudentQuizDashboardScreen> createState() => _StudentQuizDashboardScreenState();
}

class _StudentQuizDashboardScreenState extends State<StudentQuizDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizListCubit>().loadQuizzes(1); // using 1 as mock courseId for now
      context.read<QuizListCubit>().listenToRealTimeUpdates(1);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isLight ? ColorsManager.black : ColorsManager.white),
        title: Text(
          'Quiz Session',
          style: isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0xFF26C6DA),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: ColorsManager.white,
                unselectedLabelColor: ColorsManager.grayMedium,
                dividerColor: Colors.transparent,
                labelStyle: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuizList(isLight, 'Active'),
          _buildQuizList(isLight, 'Upcoming'),
          _buildQuizList(isLight, 'Completed'),
        ],
      ),
    );
  }

  Widget _buildQuizList(bool isLight, String tabType) {
    return BlocBuilder<QuizListCubit, QuizListState>(
      builder: (context, state) {
        if (state is QuizListLoading || state is QuizListInitial) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF26C6DA)));
        } else if (state is QuizListError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: ColorsManager.red),
            ),
          );
        } else if (state is QuizListLoaded) {
          final now = DateTime.now();
          final filteredQuizzes = state.quizzes.where((quiz) {
            if (tabType == 'Active') {
              return quiz.startDate.isBefore(now) && quiz.endDate.isAfter(now) && !quiz.hasAttempted;
            } else if (tabType == 'Upcoming') {
              return quiz.startDate.isAfter(now);
            } else if (tabType == 'Completed') {
              return quiz.endDate.isBefore(now) || quiz.hasAttempted;
            }
            return false;
          }).toList();

          if (filteredQuizzes.isEmpty) {
            return Center(
              child: Text(
                'No $tabType quizzes available.',
                style: (isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge).copyWith(color: ColorsManager.grayMedium),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<QuizListCubit>().loadQuizzes(1); // using 1 as mock courseId for now
            },
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
              itemCount: filteredQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = filteredQuizzes[index];
                
                String statusText = 'Live';
                if (tabType == 'Upcoming') statusText = 'Scheduled';
                if (tabType == 'Completed') statusText = quiz.areGradesPublished ? 'Graded' : 'Submitted';

                return StudentQuizCard(
                  quiz: quiz,
                  title: quiz.title,
                  courseTitle: quiz.description,
                  status: statusText,
                  date: DateFormat('dd/MM/yyyy hh:mm a').format(quiz.startDate.toLocal()),
                  duration: '${quiz.durationMinutes} Mins',
                  questionsCount: '${quiz.questionCount} Questions', 
                  actionText: tabType == 'Completed' 
                      ? (quiz.hasAttempted ? 'View Results' : null) 
                      : 'Take Quiz',
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
