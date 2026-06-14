import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../shared/config/api_constants.dart';
import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../cubit/course_details_cubit/course_details_cubit.dart';
import '../../../cubit/course_details_cubit/course_details_state.dart';
import '../../../../domain/entities/course_entity.dart';

class StudentMaterialsTab extends StatelessWidget {
  const StudentMaterialsTab({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
      builder: (context, state) {
        CourseDetailEntity? course;
        if (state is CourseDetailsLoaded) course = state.course;
        
        if (course == null) return const Center(child: CircularProgressIndicator());

        if (course.modules.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'No course materials available yet.',
                style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: course.modules.length,
          itemBuilder: (context, index) {
            return _buildModuleSection(context, course!.modules[index], isLight);
          },
        );
      },
    );
  }

  Widget _buildModuleSection(BuildContext context, ModuleEntity module, bool isLight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            module.title,
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        if (module.lessons.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
            child: Text('Coming soon...', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
          )
        else
          ...module.lessons.map((lesson) => _buildLessonItem(context, lesson, isLight)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLessonItem(BuildContext context, LessonEntity lesson, bool isLight) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          lesson.title,
          style: (isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge).copyWith(fontWeight: FontWeight.w600),
        ),
        children: [
          if (lesson.contents.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 16, top: 8),
              child: Text('No content in this lesson.', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
            )
          else
            ...lesson.contents.map((content) => _buildMaterialItem(context, content, isLight)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(BuildContext context, EducationalContentEntity content, bool isLight) {
    IconData icon = Icons.description;
    Color iconColor = ColorsManager.blue;
    
    if (content.contentType == 'PDF') {
      icon = Icons.picture_as_pdf;
      iconColor = ColorsManager.red;
    } else if (content.contentType == 'Video') {
      icon = Icons.play_circle_fill;
      iconColor = ColorsManager.yellow;
    } else if (content.contentType == 'Image') {
      icon = Icons.image;
      iconColor = ColorsManager.green;
    }

    return InkWell(
      onTap: () async {
        String fileUrl = content.fileUrl;
        
        // Ensure we only add 'uploads/' if it's not a full URL and not already prefixed
        if (!fileUrl.startsWith('http') && !fileUrl.startsWith('uploads/')) {
          fileUrl = 'uploads/$fileUrl';
        }
        
        final url = ApiConstants.fullUrl(fileUrl);
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open file.')),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 32, right: 16, bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : const Color(0xFF1A2A30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.2) : Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.fileUrl.split('/').last,
                    style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    content.contentType,
                    style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: ColorsManager.grayMedium, size: 14),
          ],
        ),
      ),
    );
  }
}
