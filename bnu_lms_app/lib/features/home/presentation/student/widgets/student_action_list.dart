import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/routes_manager/routes.dart';

class StudentActionList extends StatelessWidget {
  const StudentActionList({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Column(
      children: [
        _buildActionCard(
          context: context,
          isLight: isLight,
          title: 'Quizzes',
          subtitle: 'Course Assessments',
          description: 'Take your active quizzes',
          icon: Icons.quiz_outlined,
          onTap: () => Navigator.pushNamed(context, Routes.quizzes),
        ),
        SizedBox(height: 16),
        _buildActionCard(
          context: context,
          isLight: isLight,
          title: 'Grades',
          subtitle: 'Academic Performance',
          description: 'Check your latest updates',
          icon: Icons.stacked_line_chart,
          onTap: () => Navigator.pushNamed(context, Routes.grades),
        ),
        SizedBox(height: 16),
        _buildActionCard(
          context: context,
          isLight: isLight,
          title: 'Attendance',
          subtitle: 'Presence Record',
          description: 'View your standing',
          icon: Icons.qr_code_scanner,
          onTap: () => Navigator.pushNamed(context, Routes.attendance),
        ),
        SizedBox(height: 16),
        _buildActionCard(
          context: context,
          isLight: isLight,
          title: 'AI Assistant',
          subtitle: 'Ask Questions',
          description: 'Instant Study Help',
          icon: Icons.smart_toy_outlined,
          onTap: () => Navigator.pushNamed(context, Routes.aiChat),
          isEnhanced: true,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required bool isLight,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    bool showWarningDot = false,
    Color? descriptionColor,
    bool isEnhanced = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
          border: isLight ? null : Border.all(color: ColorsManager.blue.withValues(alpha: 0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isEnhanced)
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'ENHANCED',
                        style: TextStyle(
                          color: const Color(0xFF0097A7),
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    )
                  else
                    Text(
                      title,
                      style: TextStyle(
                        color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: isLight
                        ? AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)
                        : AppDarkTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (showWarningDot) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                      ],
                      Text(
                        description,
                        style: TextStyle(
                          color: descriptionColor ?? (isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isEnhanced 
                    ? const Color(0xFF2FBAD7) 
                    : (isLight ? const Color(0xFFE0F7FA) : const Color(0xFF2FBAD7).withValues(alpha: 0.15)),
                shape: isEnhanced ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isEnhanced ? null : BorderRadius.circular(16),
                boxShadow: isEnhanced
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2FBAD7).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: isEnhanced 
                    ? Colors.white 
                    : (isLight ? const Color(0xFF0097A7) : const Color(0xFF4DD0E1)),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
