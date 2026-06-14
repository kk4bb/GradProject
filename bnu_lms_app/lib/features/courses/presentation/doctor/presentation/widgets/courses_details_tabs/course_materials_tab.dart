import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../shared/config/api_constants.dart';
import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../cubit/course_details_cubit/course_details_cubit.dart';
import '../../../../cubit/course_details_cubit/course_details_state.dart';
import '../../../../../domain/entities/course_entity.dart';

class CourseMaterialsTab extends StatefulWidget {
  const CourseMaterialsTab({super.key});

  @override
  State<CourseMaterialsTab> createState() => _CourseMaterialsTabState();
}

class _CourseMaterialsTabState extends State<CourseMaterialsTab> {

  Future<void> _uploadMaterial(int lessonId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'mp4'],
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final extension = file.extension?.toLowerCase() ?? '';

      String contentType = 'application/octet-stream';
      if (['jpg', 'jpeg', 'png'].contains(extension)) contentType = 'Image';
      else if (extension == 'pdf') contentType = 'PDF';
      else if (extension == 'mp4') contentType = 'Video';

      if (!mounted) return;

      context.read<CourseDetailsCubit>().uploadContent(
        lessonId: lessonId,
        contentType: contentType,
        filePath: file.path!,
        fileName: file.name,
      );
    }
  }

  void _showAddModuleDialog(BuildContext context, int courseId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: const Text('Add New Module'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Module Title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(diagContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<CourseDetailsCubit>().createModule(courseId, controller.text);
                Navigator.pop(diagContext);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddLessonDialog(BuildContext context, int moduleId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: const Text('Add New Lesson'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Lesson Title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(diagContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<CourseDetailsCubit>().addLesson(moduleId, controller.text);
                Navigator.pop(diagContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return BlocConsumer<CourseDetailsCubit, CourseDetailsState>(
      listener: (context, state) {
        if (state is CourseActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage), backgroundColor: ColorsManager.green),
          );
        } else if (state is CourseActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: ColorsManager.red),
          );
        }
      },
      builder: (context, state) {
        CourseDetailEntity? course;
        if (state is CourseDetailsLoaded) course = state.course;
        if (state is CourseActionLoading) course = state.course;
        if (state is CourseActionError) course = state.course;

        if (course == null) return const Center(child: CircularProgressIndicator());

        bool isActionLoading = state is CourseActionLoading;

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
                      SizedBox(height: 2),
                      Text(
                        '${_countFiles(course)} files uploaded',
                        style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: isActionLoading ? null : () => _showAddModuleDialog(context, course!.id),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Module'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.blue,
                      foregroundColor: ColorsManager.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (isActionLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LinearProgressIndicator(color: ColorsManager.blue),
                ),

              if (course.modules.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No modules created yet.',
                      style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                    ),
                  ),
                )
              else
                ...course.modules.map((module) => _buildModuleSection(context, module, isLight, isActionLoading)),
            ],
          ),
        );
      },
    );
  }

  int _countFiles(CourseDetailEntity course) {
    int count = 0;
    for (var m in course.modules) {
      for (var l in m.lessons) {
        count += l.contents.length;
      }
    }
    return count;
  }

  Widget _buildModuleSection(BuildContext context, ModuleEntity module, bool isLight, bool isActionLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  module.title,
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: isActionLoading ? null : () => _showAddLessonDialog(context, module.id),
                icon: const Icon(Icons.add_circle_outline, color: ColorsManager.blue, size: 20),
                tooltip: 'Add Lesson',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (module.lessons.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Text('No lessons in this module.', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
          )
        else
          ...module.lessons.map((lesson) => _buildLessonItem(context, lesson, isLight, isActionLoading)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLessonItem(BuildContext context, LessonEntity lesson, bool isLight, bool isActionLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  lesson.title,
                  style: isLight ? AppLightTextStyles.bodyLarge : AppDarkTextStyles.bodyLarge,
                ),
              ),
              TextButton.icon(
                onPressed: isActionLoading ? null : () => _uploadMaterial(lesson.id),
                icon: const Icon(Icons.upload_file, size: 16),
                label: const Text('Upload'),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ),
        if (lesson.contents.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 8),
            child: Text('Empty lesson', style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
          )
        else
          ...lesson.contents.map((content) => _buildMaterialItem(context, content, isLight)),
        const Divider(indent: 16, endIndent: 16),
      ],
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

    void confirmDelete() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Material'),
          content: const Text('Are you sure you want to delete this material?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<CourseDetailsCubit>().deleteContent(content.id);
              },
              style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
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
          boxShadow: isLight
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                content.fileUrl.split('/').last,
                style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') confirmDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              icon: const Icon(Icons.more_vert, color: ColorsManager.grayMedium, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
