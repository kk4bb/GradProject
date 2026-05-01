import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class ContactAndStats extends StatelessWidget {
  const ContactAndStats({super.key});

  @override
  Widget build(BuildContext context) {
    // final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Column(
      children: [
        // Action Buttons (Email & Message)
        // Row(
        //   children: [
        //     Expanded(
        //       child: ElevatedButton.icon(
        //         onPressed: () {},
        //         icon: Icon(Icons.email_outlined, size: 18.0),
        //         label: const Text('Email'),
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: ColorsManager.blue,
        //           foregroundColor: ColorsManager.white,
        //           padding: EdgeInsets.symmetric(vertical: 12.0),
        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //           elevation: 0,
        //         ),
        //       ),
        //     ),
        //     SizedBox(width: 12.0),
        //     Expanded(
        //       child: OutlinedButton.icon(
        //         onPressed: () {},
        //         icon: Icon(Icons.chat_bubble_outline, size: 18.0),
        //         label: const Text('Message'),
        //         style: OutlinedButton.styleFrom(
        //           foregroundColor: isLight ? ColorsManager.black : ColorsManager.white,
        //           side: BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
        //           padding: EdgeInsets.symmetric(vertical: 12.0),
        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(height: 24.0),

        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatBlock(context, '04', 'COURSES'),
            _buildStatBlock(context, '128', 'STUDENTS'),
            _buildStatBlock(context, '12', 'TASKS'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBlock(BuildContext context, String value, String label) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8.0, offset: const Offset(0, 2))] : [],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}