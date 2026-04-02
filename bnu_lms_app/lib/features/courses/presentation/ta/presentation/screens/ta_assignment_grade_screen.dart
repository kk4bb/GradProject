import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../widgets/assignment_grades/active_grading_card.dart';
import '../widgets/assignment_grades/grading_summary_card.dart';
import '../widgets/assignment_grades/student_submission_tile.dart';



class TaAssignmentGradeScreen extends StatelessWidget {
  final String assignmentTitle;
  final String courseName;

  const TaAssignmentGradeScreen({
    super.key,
    this.assignmentTitle = 'HW1: Graph Theory',
    this.courseName = 'Advanced Algorithms',
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : ColorsManager.darkSurface,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: cyan),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment Grading',
              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              courseName,
              style: TextStyle(fontSize: 12.sp, color: cyan),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz, color: isLight ? ColorsManager.black : ColorsManager.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Summary Header
            GradingSummaryCard(assignmentTitle: assignmentTitle),

            SizedBox(height: 24.h),

            // 2. Filter & Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STUDENT SUBMISSIONS',
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
                Row(
                  children: [
                    Icon(Icons.filter_list, size: 16.sp, color: cyan),
                    SizedBox(width: 4.w),
                    Text(
                      'Filter',
                      style: TextStyle(color: cyan, fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // 3. Active Grading Form (Expanded)
            const ActiveGradingCard(
              studentName: 'Alex Johnson',
              studentId: '20240982',
              submissionTime: 'Submitted 2h ago',
            ),

            SizedBox(height: 16.h),

            // 4. Student List (Pending)
            const StudentSubmissionTile(
              name: 'Sarah Williams',
              status: 'PENDING REVIEW',
              isGraded: false,
            ),

            SizedBox(height: 12.h),

            // 5. Student List (Graded)
            const StudentSubmissionTile(
              name: 'David Chen',
              status: 'GRADED: 92/100',
              statusColor: ColorsManager.green,
              isGraded: true,
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}