import 'package:flutter/material.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';


class InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isLight;

  const InfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: isLight
              ? AppLightTextStyles.bodyMedium
              : AppDarkTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: isLight
              ? AppLightTextStyles.bodyLarge
              : AppDarkTextStyles.bodyLarge,
        ),
      ],
    );
  }
}
