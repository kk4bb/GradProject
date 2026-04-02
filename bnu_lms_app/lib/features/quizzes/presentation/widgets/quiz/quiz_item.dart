import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/app_sizes.dart';
import '../../../../../shared/resources/assets_manager.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';

class QuizItem extends StatelessWidget {
  const QuizItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.duration,
    required this.questionsCount,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String date;
  final String duration;
  final String questionsCount;
  final QuizStatus status;

  @override
  Widget build(BuildContext context) {

    String? getButtonLabel(QuizStatus status) {
      switch (status) {
        case QuizStatus.active:
          return "Start Quiz";
        case QuizStatus.dueSoon:
          return null;
        case QuizStatus.completed:
          return "View Results";
        case QuizStatus.missed:
          return null;
      }
    }
    final buttonLabel = getButtonLabel(status);



    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    final statusTextColor = isLight
        ? QuizLightStatusColors.text[status]!
        : QuizDarkStatusColors.text[status]!;

    final statusBackgroundColor = isLight
        ? QuizLightStatusColors.background[status]!
        : QuizDarkStatusColors.background[status]!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 358.w,
            decoration: BoxDecoration(
              color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
            child: Padding(
              padding: REdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: (isLight
                            ? AppLightTextStyles.bodyLarge
                            : AppDarkTextStyles.bodyLarge)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),

                      const Spacer(),

                      // ⭐ Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(AppSizes.radius),
                          color: statusBackgroundColor,
                        ),
                        child: Text(
                          status.name,
                          style: (isLight
                              ? AppLightTextStyles.labelMedium
                              : AppDarkTextStyles.labelMedium)
                              .copyWith(
                            color: statusTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    subtitle,
                    style: isLight
                        ? AppLightTextStyles.bodyMedium
                        : AppDarkTextStyles.bodyMedium,
                  ),

                  SizedBox(height: AppSizes.mediumSpacing),

                  Row(
                    children: [
                      ImageIcon(AssetImage(IconsManager.time)),
                      Text(
                        date,
                        style: isLight
                            ? AppLightTextStyles.bodyMedium
                            : AppDarkTextStyles.bodyMedium,
                      ),
                    ],
                  ),

                  SizedBox(height: AppSizes.mediumSpacing),

                  Text(
                    '$duration • $questionsCount',
                    style: isLight
                        ? AppLightTextStyles.bodyMedium
                        : AppDarkTextStyles.bodyMedium,
                  ),

                  SizedBox(height: AppSizes.mediumSpacing),

                  if (buttonLabel != null)
                    CustomElevatedButton(
                      label: buttonLabel,
                      onTap: () {
                        // TODO: Add navigation logic per status
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// ENUM
// ------------------------------------------------------------

enum QuizStatus {
  active,
  dueSoon,
  completed,
  missed,
}

// ------------------------------------------------------------
// LIGHT MODE COLORS
// ------------------------------------------------------------

class QuizLightStatusColors {
  static const Map<QuizStatus, Color> text = {
    QuizStatus.active: Color(0xFF1E40AF),       // Darker blue
    QuizStatus.dueSoon: Color(0xFFB45309),      // Dark orange
    QuizStatus.completed: Color(0xFF1B5E20),    // Dark green
    QuizStatus.missed: Color(0xFFB71C1C),       // Dark red
  };

  static const Map<QuizStatus, Color> background = {
    QuizStatus.active: Color(0xFFE8EDFF),       // Light blue
    QuizStatus.dueSoon: Color(0xFFFFF4E5),      // Light yellow
    QuizStatus.completed: Color(0xFFE3F6EC),    // Light green
    QuizStatus.missed: Color(0xFFF9E3E3),       // Light red
  };
}

// ------------------------------------------------------------
// DARK MODE COLORS
// ------------------------------------------------------------

class QuizDarkStatusColors {
  static const Map<QuizStatus, Color> text = {
    QuizStatus.active: Color(0xFF5A9BEB),
    QuizStatus.dueSoon: Color(0xFFCAA515),
    QuizStatus.completed: Color(0xFF4CE483),
    QuizStatus.missed: Color(0xFFE57373),
  };

  static const Map<QuizStatus, Color> background = {
    QuizStatus.active: Color(0xFF223049),
    QuizStatus.dueSoon: Color(0xFF453A1A),
    QuizStatus.completed: Color(0xFF1D3C2B),
    QuizStatus.missed: Color(0xFF402224),
  };
}
