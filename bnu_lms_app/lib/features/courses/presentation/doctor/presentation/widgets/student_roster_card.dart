import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/api_constants.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

class StudentRosterCard extends StatelessWidget {
  final String name;
  final String id;
  final String? avatarUrl;

  const StudentRosterCard({
    required this.name,
    required this.id,
    this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.2),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? Image.network(
                      avatarUrl!.startsWith('http')
                          ? avatarUrl!
                          : '${ApiConstants.baseUrl.replaceAll('api/', '')}${avatarUrl!.startsWith('/') ? avatarUrl!.substring(1) : avatarUrl!}',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.person, color: ColorsManager.grayMedium),
                    )
                  : Icon(Icons.person, color: ColorsManager.grayMedium),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
                Text(id, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
