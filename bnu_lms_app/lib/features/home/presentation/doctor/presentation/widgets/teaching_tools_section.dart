import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/routes_manager/routes.dart';

import '../../../../../grades/presentation/widgets/grades_course_selection_screen.dart';

class TeachingToolsSection extends StatelessWidget {
  final bool isInstructor;

  const TeachingToolsSection({super.key, required this.isInstructor});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Teaching Tools',
            style: isLight
                ? AppLightTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w900)
                : AppDarkTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        SizedBox(height: 16),

        // Primary Card (Grade Management)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GradesCourseSelectionScreen(isInstructor: isInstructor),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2FBAD7), Color(0xFF0097A7)], // Cyan gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2FBAD7).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Optional Background Icon Watermark
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      Icons.military_tech,
                      size: 150,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.insert_chart_outlined, color: Colors.white, size: 28),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Grade Management',
                                  style: AppDarkTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Manage term work, midterms, finals, and student grades',
                                  style: AppDarkTextStyles.labelMedium.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 20),

        // Secondary Cards Grid (Create Assessment & Take Attendance)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Card 1
              Expanded(
                child: _buildSquarishCard(
                  context: context,
                  isLight: isLight,
                  icon: Icons.post_add_rounded,
                  title: 'Create\nAssessment',
                  onTap: () => Navigator.pushNamed(context, Routes.quizWizard),
                ),
              ),
              SizedBox(width: 16),
              // Card 2
              Expanded(
                child: _buildSquarishCard(
                  context: context,
                  isLight: isLight,
                  icon: Icons.campaign_outlined,
                  title: 'Manage\nAnnouncements',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.manageAnnouncements);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSquarishCard({
    required BuildContext context,
    required bool isLight,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsManager.blue.withValues(alpha: 0.05)),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLight 
                    ? const Color(0xFFE0F7FA) // Light Cyan for Light Mode
                    : const Color(0xFF2FBAD7).withValues(alpha: 0.15), // Subtle Cyan for Dark Mode
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon, 
                color: isLight ? const Color(0xFF0097A7) : const Color(0xFF4DD0E1), // Bright Cyan in Dark Mode
                size: 24
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: isLight
                  ? AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)
                  : AppDarkTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
