import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../shared/di/injection.dart';
import 'package:bnu_lms_app/features/grades/presentation/cubit/grades_cubit.dart';
import 'package:bnu_lms_app/features/grades/presentation/cubit/grades_state.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../student_roster_card.dart';

class CourseStudentsTab extends StatelessWidget {
  final int courseId;

  const CourseStudentsTab({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GradesCubit>()..loadCourseGrades(courseId),
      child: const _CourseStudentsTabBody(),
    );
  }
}

class _CourseStudentsTabBody extends StatelessWidget {
  const _CourseStudentsTabBody();

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return BlocBuilder<GradesCubit, GradesState>(
      builder: (context, state) {
        if (state is GradesLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: ColorsManager.blue),
            ),
          );
        } else if (state is GradesError) {
          return Center(
            child: Text(state.message, style: const TextStyle(color: ColorsManager.red)),
          );
        } else if (state is GradesLoaded) {
          final students = state.courseGrades;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class Roster',
                          style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${students.length} Students Enrolled',
                          style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkBlue ,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.sort, size: 16, color: ColorsManager.blue),
                          SizedBox(width: 4),
                          Text(
                            'Sort',
                            style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),

                // Student List
                if (students.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text('No students enrolled yet.', style: TextStyle(color: ColorsManager.grayMedium)),
                    ),
                  )
                else
                  ...students.map((s) => StudentRosterCard(
                    name: s.studentName, 
                    id: 'ID: ${s.studentId}',
                    avatarUrl: s.studentAvatarUrl,
                  )),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}