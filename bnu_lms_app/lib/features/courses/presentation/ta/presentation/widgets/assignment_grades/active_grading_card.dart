import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/widgets/custom_elevated_button.dart';


class ActiveGradingCard extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String submissionTime;

  const ActiveGradingCard({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.submissionTime,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
    );

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: cyan, width: 1.5),
        boxShadow: isLight
            ? [BoxShadow(color: cyan.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(radius: 20.0, backgroundColor: Colors.orange.shade200),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ID: $studentId • $submissionTime',
                      style: TextStyle(fontSize: 10.0, color: ColorsManager.grayMedium),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.visibility_outlined, size: 14.0, color: cyan),
                label: Text('View PDF', style: TextStyle(color: cyan, fontSize: 10.0)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: cyan.withValues(alpha: 0.5)),
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),
          Divider(color: ColorsManager.grayMedium.withValues(alpha: 0.1)),
          SizedBox(height: 20.0),

          // Grade Input
          Text(
            'GRADE (0-100)',
            style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: ColorsManager.grayMedium),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              SizedBox(
                width: 100.0,
                child: TextField(
                  style: isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: '--',
                    hintStyle: TextStyle(color: ColorsManager.grayMedium),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: cyan)),
                    filled: true,
                    fillColor: isLight ? Colors.grey.shade50 : ColorsManager.darkBackground,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 12.0),
              Text(
                '/ 100',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: ColorsManager.grayMedium),
              ),
            ],
          ),

          SizedBox(height: 20.0),

          // Feedback Input
          Text(
            'FEEDBACK COMMENT',
            style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: ColorsManager.grayMedium),
          ),
          SizedBox(height: 8.0),
          TextField(
            maxLines: 3,
            style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Excellent work on the complexity analysis...',
              hintStyle: TextStyle(color: ColorsManager.grayMedium.withValues(alpha: 0.5)),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: cyan)),
              filled: true,
              fillColor: isLight ? Colors.grey.shade50 : ColorsManager.darkBackground,
            ),
          ),

          SizedBox(height: 24.0),

          // Save Button
          CustomElevatedButton(
            label: 'Save Grade',
            onTap: () {},
            backgroundColor: cyan,
            prefixIcon: const Icon(Icons.save_outlined, color: Colors.white, size: 20),
            radius: 12.0,
          ),
        ],
      ),
    );
  }
}