import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/assignment_entity.dart';

class AssignmentResultScreen extends StatelessWidget {
  final AssignmentEntity assignment;

  const AssignmentResultScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        title: Text(
          'Assignment Results', 
          style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _GradeCircle(grade: assignment.grade ?? 0, maxPoints: assignment.maxPoints),
            SizedBox(height: 32),
            _FeedbackCard(feedback: assignment.feedback ?? "No feedback provided yet."),
          ],
        ),
      ),
    );
  }
}

class _GradeCircle extends StatelessWidget {
  final double grade;
  final double maxPoints;

  const _GradeCircle({required this.grade, required this.maxPoints});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: grade / maxPoints,
            strokeWidth: 12,
            backgroundColor: ColorsManager.blue.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(ColorsManager.blue),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${grade.toInt()}',
              style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              'Out of ${maxPoints.toInt()}',
              style: isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final String feedback;

  const _FeedbackCard({required this.feedback});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : ColorsManager.blue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.comment_outlined, color: ColorsManager.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Instructor Feedback', 
                style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            feedback,
            style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

// class _OriginalityReport extends StatelessWidget {
//   final int percentage;
//
//   const _OriginalityReport({required this.percentage});
//
//   @override
//   Widget build(BuildContext context) {
//     final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorsManager.blue.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.verified_user_outlined, color: ColorsManager.green),
//               SizedBox(width: 8),
//               Text(
//                 'Originality Report',
//                 style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium
//               ),
//             ],
//           ),
//           Text(
//             '$percentage% Similarity',
//             style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.green, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;
//
//   const _SectionTitle({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)
//       ),
//     );
//   }
// }

// class _MasteryProgressBar extends StatelessWidget {
//   final String label;
//   final double value;
//   final Color color;
//
//   const _MasteryProgressBar({required this.label, required this.value, required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label, style: isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall),
//             Text('${(value * 100).toInt()}%', style: (isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall).copyWith(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         SizedBox(height: 6),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: value,
//             minHeight: 8,
//             backgroundColor: color.withValues(alpha: 0.1),
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//           ),
//         ),
//       ],
//     );
//   }
// }
