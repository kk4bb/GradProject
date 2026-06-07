import 'package:bnu_lms_app/features/quizzes/presentation/widgets/quiz/quiz_item.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/providers/theme_provider.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            localizations.quizzes,
            style: isLight
                ? AppLightTextStyles.headlineLarge
                : AppDarkTextStyles.headlineLarge,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isLight ? Colors.grey[100] : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: isLight ? Colors.black87 : Colors.white70,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Upcoming"),
                  Tab(text: "Completed"),
                  Tab(text: "Missed"),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  // ----------------------------------
                  // 🔵 TAB 1 — All Quizzes
                  // ----------------------------------
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.quizDetails);
                          },
                          child: QuizItem(
                            title: "Midterm Exam",
                            status: QuizStatus.active,
                            subtitle: "Introduction to Programming",
                            date: "Oct 26, 2024",
                            duration: "30 min",
                            questionsCount: "20 Questions",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        QuizItem(
                          title: "Quiz 1",
                          status: QuizStatus.completed,
                          subtitle: "Object Oriented Programming",
                          date: "Oct 27, 2024",
                          duration: "10 min",
                          questionsCount: "15 Questions",
                        ),
                        SizedBox(height: 10.h),
                        QuizItem(
                          title: "Midterm 2 Exam",
                          status: QuizStatus.dueSoon,
                          subtitle: "Database Systems",
                          date: "Oct 30, 2024",
                          duration: "60 min",
                          questionsCount: "40 Questions",
                        ),
                        SizedBox(height: 10.h),
                        QuizItem(
                          title: "Linear Algebra Quiz",
                          status: QuizStatus.missed,
                          subtitle: "Database Systems",
                          date: "Oct 15, 2024",
                          duration: "30 min",
                          questionsCount: "20 Questions",
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),

                  // ----------------------------------
                  // 🟡 TAB 2 — Upcoming
                  // ----------------------------------
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        QuizItem(
                          title: "Midterm Exam",
                          status: QuizStatus.active,
                          subtitle: "Introduction to Programming",
                          date: "Oct 26, 2024",
                          duration: "30 min",
                          questionsCount: "20 Questions",
                        ),
                        SizedBox(height: 10.h),
                        QuizItem(
                          title: "Quiz 1",
                          status: QuizStatus.dueSoon,
                          subtitle: "Object Oriented Programming",
                          date: "Oct 27, 2024",
                          duration: "10 min",
                          questionsCount: "15 Questions",
                        ),
                      ],
                    ),
                  ),

                  // ----------------------------------
                  // 🟢 TAB 3 — Completed
                  // ----------------------------------
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        QuizItem(
                          title: "Midterm 2 Exam",
                          status: QuizStatus.completed,
                          subtitle: "Database Systems",
                          date: "Oct 15, 2024",
                          duration: "60 min",
                          questionsCount: "40 Questions",
                        ),
                      ],
                    ),
                  ),

                  // ----------------------------------
                  // 🔴 TAB 4 — Grade/Missed
                  // ----------------------------------
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        QuizItem(
                          title: "Weekly Quiz",
                          status: QuizStatus.missed,
                          subtitle: "Data Structures",
                          date: "Oct 10, 2024",
                          duration: "15 min",
                          questionsCount: "10 Questions",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}