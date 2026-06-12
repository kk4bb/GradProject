import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/assets_manager.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Column(
      children: [
        // Logo Container
        Container(
          height: 80, // Set explicit height/width for a perfect circle
          width: 80,
          padding: EdgeInsets.all(12), // Padding inside the white circle
          decoration: BoxDecoration(
            // 1. FIX: Always keep the container white to hide the image's white background
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          // 2. FIX: Wrap in ClipOval so the square corners of the image don't bleed out
          child: ClipOval(
            child: Image.asset(
              ImagesManager.bnuLogo,
              fit: BoxFit.contain,
            ),
          ),
        ),

        SizedBox(height: 24),

        // Titles
        Text(
          'Benha National University',
          textAlign: TextAlign.center,
          style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium)
              .copyWith(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        SizedBox(height: 8),
        Text(
          'OFFICIAL ACADEMIC SYSTEM',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: cyan,
          ),
        ),
      ],
    );
  }
}