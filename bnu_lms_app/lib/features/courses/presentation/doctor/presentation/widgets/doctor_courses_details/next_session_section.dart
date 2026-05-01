import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class NextSessionSection extends StatelessWidget {
  const NextSessionSection({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Session',
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: ColorsManager.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Tomorrow',
                  style: AppLightTextStyles.labelSmall.copyWith(
                    color: ColorsManager.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              // Date Box
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Text('OCT', style: AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.grayMedium)),
                    Text(
                      '24',
                      style: isLight
                          ? AppLightTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold)
                          : AppDarkTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              // Session Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Graph Traversals (DFS/BFS)',
                      style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
                    ),
                    SizedBox(height: 6.0),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14.0, color: ColorsManager.grayMedium),
                        SizedBox(width: 4.0),
                        Text('09:00 AM - 11:30 AM', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14.0, color: ColorsManager.grayMedium),
                        SizedBox(width: 4.0),
                        Text('Room 304, Science Block', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}