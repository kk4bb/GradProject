import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';

class ForumTaskCard extends StatelessWidget {
  const ForumTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18.0, backgroundColor: const Color(0xFFEAB398)),
              SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Algorithms Course', style: TextStyle(color: cyan, fontSize: 13.0, fontWeight: FontWeight.bold)),
                  Text('14m ago', style: TextStyle(color: ColorsManager.grayMedium, fontSize: 11.0)),
                ],
              )
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            'Clarification on Big O for Task 2?',
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            '"Hi TA, I\'m confused if we should consider the space complexity for the recursive calls..."',
            style: TextStyle(color: ColorsManager.grayMedium, fontSize: 13.0, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorsManager.grayMedium,
                    side: BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                  child: const Text('Dismiss', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cyan,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                  child: const Text('Reply', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}