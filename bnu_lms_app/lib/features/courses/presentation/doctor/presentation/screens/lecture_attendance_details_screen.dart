import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../attendance/domain/entities/attendance_record_entity.dart';
import '../widgets/student_roster_card.dart';

class LectureAttendanceDetailsScreen extends StatelessWidget {
  final String lectureTitle;
  final String date;
  final List<AttendanceRecordEntity> attendees;

  const LectureAttendanceDetailsScreen({
    super.key,
    required this.lectureTitle,
    required this.date,
    required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isLight ? ColorsManager.black : ColorsManager.white,
            size: 20,
          ),
        ),
        title: Text(
          'Lecture Details',
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lectureTitle,
                  style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: ColorsManager.grayMedium),
                    SizedBox(width: 8),
                    Text(
                      date,
                      style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  '${attendees.length} Students Present',
                  style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: attendees.isEmpty
                ? Center(
                    child: Text(
                      'No students attended this lecture.',
                      style: TextStyle(
                        color: ColorsManager.grayMedium,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: attendees.length,
                    itemBuilder: (context, index) {
                      final attendee = attendees[index];
                      return StudentRosterCard(
                        name: attendee.studentName,
                        id: 'ID: ${attendee.studentId}',
                        avatarUrl: attendee.profilePictureUrl,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
