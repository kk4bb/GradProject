import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';


class ForumAnswerInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const ForumAnswerInput({
    required this.controller,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Answer',
              style: isLight
                  ? AppLightTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorsManager.black,
              )
                  : AppDarkTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorsManager.darkTextPrimary,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isLight
                          ? ColorsManager.lightBackground
                          : ColorsManager.darkBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isLight
                            ? ColorsManager.grayMedium.withValues(alpha: 0.3)
                            : ColorsManager.darkTextSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      maxLines: 1,
                      style: TextStyle(
                        color: isLight
                            ? ColorsManager.black
                            : ColorsManager.darkTextPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your answer here...',
                        hintStyle: TextStyle(
                          color: isLight
                              ? ColorsManager.grayMedium
                              : ColorsManager.darkTextSecondary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.blue,
                    foregroundColor: ColorsManager.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Post Answer',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}