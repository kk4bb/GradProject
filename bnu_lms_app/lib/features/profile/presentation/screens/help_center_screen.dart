import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help Center',
          style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isLight ? ColorsManager.black : ColorsManager.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact IT Support Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.blue : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isLight ? [BoxShadow(color: ColorsManager.blue.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.support_agent, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact IT Support',
                          style: AppLightTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'support@campusconnect.edu',
                          style: AppLightTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: (isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            _buildFAQItem(
              question: 'How to scan QR code?',
              answer: 'Go to the Dashboard and tap on the QR code icon in the top right corner. Ensure you have granted camera permissions.',
              isLight: isLight,
            ),
            _buildFAQItem(
              question: 'How to view my grades?',
              answer: 'Navigate to the "Grades" tab from the main navigation bar at the bottom to view a detailed breakdown of your academic performance.',
              isLight: isLight,
            ),
            _buildFAQItem(
              question: 'Can I change my profile picture?',
              answer: 'Yes, you can change your profile picture by going to Profile > Edit Profile and tapping on the camera icon over your avatar.',
              isLight: isLight,
            ),
            _buildFAQItem(
              question: 'Where can I find assignment deadlines?',
              answer: 'Deadlines are displayed in the "Tasks" widget on your dashboard, and you can also find them inside each individual Course Details screen under the "Assignments" tab.',
              isLight: isLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer, required bool isLight}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : ColorsManager.darkBackground),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: ColorsManager.blue,
          collapsedIconColor: isLight ? ColorsManager.grayDark : ColorsManager.white,
          title: Text(
            question,
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.w600),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                answer,
                style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(
                  color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
