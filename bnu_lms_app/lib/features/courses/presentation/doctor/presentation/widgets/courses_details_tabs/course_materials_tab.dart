import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/network/repositories/course_repository.dart';
import '../../../../../data/models/course_model.dart';

class CourseMaterialsTab extends StatefulWidget {
  final CourseDetail course;
  const CourseMaterialsTab({required this.course, super.key});

  @override
  State<CourseMaterialsTab> createState() => _CourseMaterialsTabState();
}

class _CourseMaterialsTabState extends State<CourseMaterialsTab> {
  final CourseRepository _courseRepository = CourseRepository();
  late CourseDetail _currentCourse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
  }

  Future<void> _refreshCourse() async {
    setState(() => _isLoading = true);
    try {
      final updatedCourse = await _courseRepository.getCourseDetails(_currentCourse.id);
      setState(() {
        _currentCourse = updatedCourse;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to refresh: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showAddDialog({required String title, required Function(String) onConfirm, String label = 'Title'}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              onConfirm(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddContentDialog(int lessonId) {
    final urlController = TextEditingController();
    String selectedType = 'PDF';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Content'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                items: ['PDF', 'Video', 'Link'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (val) => setDialogState(() => selectedType = val!),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL / Link'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                try {
                  await _courseRepository.addContent(lessonId, selectedType, urlController.text);
                  Navigator.pop(context);
                  _refreshCourse();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    int totalFiles = 0;
    for (var module in _currentCourse.modules) {
      for (var lesson in module.lessons) {
        totalFiles += lesson.contents.length;
      }
    }

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
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
                  SizedBox(height: 2.0),
                  Text(
                    '$totalFiles items available',
                    style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showAddDialog(
                  title: 'Add New Module',
                  onConfirm: (val) async {
                    try {
                      await _courseRepository.createModule(_currentCourse.id, val);
                      _refreshCourse();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: ColorsManager.blue,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: ColorsManager.white, size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        'Add Module',
                        style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),

          if (_currentCourse.modules.isEmpty)
            const Center(child: Text('No materials uploaded yet.'))
          else
            ..._currentCourse.modules.map((module) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      module.title,
                      style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                          .copyWith(fontWeight: FontWeight.bold, color: ColorsManager.blue),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20, color: ColorsManager.blue),
                      onPressed: () => _showAddDialog(
                        title: 'Add Lesson to ${module.title}',
                        onConfirm: (val) async {
                          try {
                            await _courseRepository.addLesson(module.id, val);
                            _refreshCourse();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ...module.lessons.map((lesson) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            lesson.title,
                            style: (isLight ? AppLightTextStyles.titleSmall : AppDarkTextStyles.titleSmall),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.note_add_outlined, size: 18, color: ColorsManager.grayMedium),
                          onPressed: () => _showAddContentDialog(lesson.id),
                        ),
                      ],
                    ),
                    ...lesson.contents.map((content) => _buildMaterialItem(
                      context,
                      content.fileUrl.split('/').last,
                      content.contentType,
                      content.contentType.toLowerCase() == 'video' ? Icons.play_circle_fill : Icons.description,
                      content.contentType.toLowerCase() == 'video' ? ColorsManager.yellow : ColorsManager.blue,
                    )),
                  ],
                )),
                const Divider(),
              ],
            )),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(BuildContext context, String title, String details, IconData icon, Color iconColor) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 12.0, left: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8.0, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: iconColor, size: 24.0),
          ),
          SizedBox(width: 16.0),
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
                SizedBox(height: 4.0),
                Text(details, style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: ColorsManager.grayMedium, size: 20.0),
        ],
      ),
    );
  }
}
