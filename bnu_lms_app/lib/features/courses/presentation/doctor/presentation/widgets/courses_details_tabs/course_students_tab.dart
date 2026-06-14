import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import 'package:bnu_lms_app/features/courses/domain/entities/course_entity.dart';
import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../student_roster_card.dart';

class CourseStudentsTab extends StatefulWidget {
  final List<CourseStudentEntity> students;

  const CourseStudentsTab({super.key, required this.students});

  @override
  State<CourseStudentsTab> createState() => _CourseStudentsTabState();
}

class _CourseStudentsTabState extends State<CourseStudentsTab> {
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    
    final sortedStudents = List<CourseStudentEntity>.from(widget.students)
      ..sort((a, b) {
        final nameA = '${a.firstName} ${a.lastName}'.toLowerCase();
        final nameB = '${b.firstName} ${b.lastName}'.toLowerCase();
        return _isAscending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
      });

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
                    '${widget.students.length} Students Enrolled',
                    style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isAscending = !_isAscending;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLight ? ColorsManager.lightBlueAccent : ColorsManager.darkBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(_isAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined, size: 16, color: ColorsManager.blue),
                      SizedBox(width: 4),
                      Text(
                        _isAscending ? 'A-Z' : 'Z-A',
                        style: AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),

          // Student List
          if (widget.students.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('No students enrolled yet.', style: TextStyle(color: ColorsManager.grayMedium)),
              ),
            )
          else
            ...sortedStudents.map((s) => StudentRosterCard(
              name: '${s.firstName} ${s.lastName}',
              avatarUrl: s.profilePictureUrl,
            )),
        ],
      ),
    );
  }
}