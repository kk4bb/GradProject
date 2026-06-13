import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';


class LearningOutcomesSection extends StatelessWidget {
  final List<String> outcomes;

  const LearningOutcomesSection({
    required this.outcomes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Outcomes',
            style: isLight
                ? AppLightTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            )
                : AppDarkTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ...outcomes.map((outcome) => _buildOutcomeItem(outcome, isLight)),
        ],
      ),
    );
  }

  Widget _buildOutcomeItem(String outcome, bool isLight) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: ColorsManager.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              outcome,
              style: isLight
                  ? AppLightTextStyles.bodyMedium.copyWith(
                color: ColorsManager.grayDark,
                height: 1.5,
              )
                  : AppDarkTextStyles.bodyMedium.copyWith(
                color: ColorsManager.darkTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}