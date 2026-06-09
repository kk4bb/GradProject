import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

import 'package:bnu_lms_app/features/courses/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class CourseMaterialsTab extends StatelessWidget {
  final CourseDetail courseDetail;
  const CourseMaterialsTab({required this.courseDetail, super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    
    final allContent = courseDetail.modules.expand((m) => m.lessons.expand((l) => l.contents)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Materials',
                    style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${allContent.length} files uploaded this semester',
                    style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: ColorsManager.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Upload',
                      style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ...allContent.map((content) {
            IconData icon = Icons.description;
            Color color = ColorsManager.blue;
            if (content.contentType.contains('pdf')) {
              icon = Icons.picture_as_pdf;
              color = ColorsManager.red;
            } else if (content.contentType.contains('video')) {
              icon = Icons.play_circle_fill;
              color = ColorsManager.yellow;
            }
            
            return _buildMaterialItem(
              context,
              content.fileUrl.split('/').last,
              'Type: ${content.contentType}',
              icon,
              color,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(BuildContext context, String title, String details, IconData icon, Color iconColor) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(details, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: ColorsManager.grayMedium, size: 20),
        ],
      ),
    );
  }
}