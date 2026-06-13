import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class TaCourseOverviewTab extends StatelessWidget {
  const TaCourseOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. Section Information
          const _SectionInfoCard(),
          SizedBox(height: 24),

          // 3. This Week's Labs
          _buildSectionTitle(context, "This Week's Labs"),
          SizedBox(height: 12),
          const _LabStatusItem(
            title: 'Lab 04: Recursion',
            time: 'Tue • 02:00 PM - 04:00 PM',
            status: 'COMPLETED',
            isCompleted: true,
          ),
          SizedBox(height: 12),
          const _LabStatusItem(
            title: 'Lab 05: Data Structures',
            time: 'Thu • 02:00 PM - 04:00 PM',
            status: 'UPCOMING',
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Text(
      title,
      style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}

// // ---------------------------------------------------------------------------
// // WIDGET: TA COURSE HEADER
// // ---------------------------------------------------------------------------
// class _TaCourseHeaderCard extends StatelessWidget {
//   const _TaCourseHeaderCard();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 180,
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         image: const DecorationImage(
//           image: AssetImage('assets/images/course_bg_code.png'), // Replace with your image
//           fit: BoxFit.cover,
//         ),
//         // Dark Overlay for readability
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.8)],
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2FBAD7), // TA Cyan
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               'TA ACCESS • SECTION B',
//               style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'CS101: Intro to Computer Science',
//             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Semester: Fall 2024',
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   'Syllabus',
//                   style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// ---------------------------------------------------------------------------
// WIDGET: SECTION INFO CARD
// ---------------------------------------------------------------------------
class _SectionInfoCard extends StatelessWidget {
  const _SectionInfoCard();

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: const Color(0xFF2FBAD7), width: 4)), // Cyan Accent
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: const Color(0xFF2FBAD7), size: 20),
              SizedBox(width: 8),
              Text(
                'Section Information',
                style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(isLight, 'LEAD PROFESSOR', 'Dr. Sarah Mitchell'),
              _buildInfoItem(isLight, 'SCHEDULE', 'Mon, Wed • 10:00 AM'),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoItem(isLight, 'LAB LOCATION', 'Engineering Hall, Room 402', icon: Icons.location_on_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoItem(bool isLight, String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: ColorsManager.grayMedium, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isLight ? ColorsManager.black : ColorsManager.white),
              SizedBox(width: 4),
            ],
            Text(
              value,
              style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// WIDGET: LAB STATUS ITEM
// ---------------------------------------------------------------------------
class _LabStatusItem extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final bool isCompleted;

  const _LabStatusItem({
    required this.title,
    required this.time,
    required this.status,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final statusColor = isCompleted ? ColorsManager.green : Colors.orange;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))] : [],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFE0F7FA) : ColorsManager.darkBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'TUE\n12',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF2FBAD7)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: ColorsManager.grayMedium),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}