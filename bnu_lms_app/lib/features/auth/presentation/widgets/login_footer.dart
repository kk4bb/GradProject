import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 16, color: ColorsManager.grayMedium),
            SizedBox(width: 8),
            Text(
              'Secure Enterprise Access',
              style: TextStyle(
                fontSize: 12,
                color: ColorsManager.grayMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Restricted access system. Account creation is\nmanaged by university administration.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: ColorsManager.grayMedium,
            height: 1.5,
          ),
        ),
        SizedBox(height: 24),
        Text(
          '© 2026 Benha National University - IT Support',
          style: TextStyle(
            fontSize: 11,
            color: isLight ? ColorsManager.grayMedium : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}