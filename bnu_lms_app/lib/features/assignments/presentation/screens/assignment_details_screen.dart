import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/assignment_entity.dart';
import 'submit_assignment_screen.dart';

class AssignmentDetailsScreen extends StatelessWidget {
  final AssignmentEntity assignment;

  const AssignmentDetailsScreen({super.key, required this.assignment});

  String _getTimeLeft(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    if (difference.isNegative) return "Deadline Passed";
    if (difference.inDays > 0) return "${difference.inDays} Days Left";
    if (difference.inHours > 0) return "${difference.inHours} Hours Left";
    if (difference.inMinutes > 0) return "${difference.inMinutes} Mins Left";
    return "Due Now";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        title: Text(
          'Assignment Details', 
          style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            SizedBox(height: 24),
            _buildSectionTitle(context, 'Instructions'),
            SizedBox(height: 12),
            _buildInstructionsSection(context),
            if (assignment.filePath != null && assignment.filePath!.isNotEmpty) ...[
              SizedBox(height: 24),
              _buildSectionTitle(context, 'Reference Materials'),
              SizedBox(height: 12),
              _buildReferenceMaterialsSection(context),
            ],
            if (assignment.grade != null) ...[
              SizedBox(height: 24),
              _buildGradedCard(context),
            ],
            SizedBox(height: 24),
            _buildSectionTitle(context, 'Submission Status'),
            SizedBox(height: 12),
            _buildSubmissionStatusSection(context),
            SizedBox(height: 24),
            _buildSectionTitle(context, 'Instructor'),
            SizedBox(height: 12),
            _buildInstructorSection(context),
            SizedBox(height: 40),
            _buildSubmissionAction(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Text(
      title, 
      style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface, 
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  assignment.title, 
                  style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall
                )
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (assignment.status.toLowerCase() == 'pending' ? ColorsManager.yellow : ColorsManager.green).withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(
                  assignment.status, 
                  style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(
                    color: assignment.status.toLowerCase() == 'pending' ? ColorsManager.yellow : ColorsManager.green
                  )
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: ColorsManager.grayMedium),
              SizedBox(width: 8),
              Text(
                'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}, ${assignment.dueDate.hour}:${assignment.dueDate.minute}', 
                style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium
              ),
              const Spacer(),
              Text(
                '${assignment.maxPoints} Points', 
                style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(fontWeight: FontWeight.bold, color: ColorsManager.blue)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradedCard(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: ColorsManager.blue, size: 28),
              SizedBox(width: 8),
              Text(
                'Graded',
                style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: ColorsManager.blue),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Your Grade: ${assignment.grade} / ${assignment.maxPoints}',
            style: (isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall).copyWith(fontWeight: FontWeight.bold),
          ),
          if (assignment.feedback != null && assignment.feedback!.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              'Instructor Feedback:',
              style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.bold, color: ColorsManager.grayMedium),
            ),
            SizedBox(height: 4),
            Text(
              assignment.feedback!,
              style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildInstructionsSection(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.blue.withValues(alpha: 0.05),
        border: Border(left: BorderSide(color: ColorsManager.blue, width: 4)),
      ),
      child: Text(
        assignment.description,
        style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
      ),
    );
  }

  Widget _buildReferenceMaterialsSection(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final fileName = assignment.filePath?.split('/').last ?? 'Reference_Material.pdf';
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(Icons.picture_as_pdf, color: ColorsManager.red, size: 30),
      title: Text(
        fileName, 
        style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium
      ),
      subtitle: Text(
        'Tap to download', 
        style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall
      ),
      trailing: const Icon(Icons.download_rounded, color: ColorsManager.blue),
      onTap: () {},
    );
  }

  Widget _buildSubmissionStatusSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _buildStatusCard(context, 'Time Left', _getTimeLeft(assignment.dueDate), Icons.timer_outlined),
    );
  }

  Widget _buildStatusCard(BuildContext context, String title, String value, IconData icon) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface, 
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          Icon(icon, color: ColorsManager.blue, size: 24),
          SizedBox(height: 8),
          Text(
            title, 
            style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium)
          ),
          SizedBox(height: 4),
          Text(
            value, 
            style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorSection(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return ListTile(
      contentPadding: EdgeInsets.all(12),
      tileColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: CircleAvatar(
        radius: 24, 
        backgroundColor: ColorsManager.blue.withValues(alpha: 0.2), 
        child: const Icon(Icons.person, color: ColorsManager.blue)
      ),
      title: Text(
        assignment.instructorName ?? 'Unknown Instructor', 
        style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium
      ),
      subtitle:  Text(
        'Lead Instructor', 
        style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall
      ),
      trailing: IconButton(
        icon: const Icon(Icons.mail_outline, color: ColorsManager.blue), 
        onPressed: () {}
      ),
    );
  }

  Widget _buildSubmissionAction(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final isDeadlinePassed = DateTime.now().isAfter(assignment.dueDate);
    final isSubmitted = assignment.status.toLowerCase() == 'submitted';

    if (assignment.grade != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsManager.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorsManager.blue),
        ),
        child: Column(
          children: [
            Icon(Icons.stars_rounded, color: ColorsManager.blue, size: 32),
            SizedBox(height: 8),
            Text(
              'Assignment Graded',
              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: ColorsManager.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (isSubmitted) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsManager.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorsManager.green),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle, color: ColorsManager.green, size: 32),
            SizedBox(height: 8),
            Text(
              'Assignment Submitted Successfully',
              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: ColorsManager.green),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (isDeadlinePassed) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsManager.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorsManager.red),
        ),
        child: Column(
          children: [
            Icon(Icons.warning_amber_rounded, color: ColorsManager.red, size: 32),
            SizedBox(height: 8),
            Text(
              'Submission Closed: Deadline has passed.',
              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: ColorsManager.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubmitAssignmentScreen(assignment: assignment)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.blue,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          'Proceed to Submission', 
          style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: Colors.white)
        ),
      ),
    );
  }
}
