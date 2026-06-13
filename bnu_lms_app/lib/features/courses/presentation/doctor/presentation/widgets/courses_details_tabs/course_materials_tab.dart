import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:file_picker/file_picker.dart';

import '../../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';

class CourseMaterialsTab extends StatefulWidget {
  const CourseMaterialsTab({super.key});

  @override
  State<CourseMaterialsTab> createState() => _CourseMaterialsTabState();
}

class _CourseMaterialsTabState extends State<CourseMaterialsTab> {
  bool _isUploading = false;
  
  Future<void> _mockUploadMaterial() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _isUploading = true;
      });

      // Simulate network upload delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isUploading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File uploaded successfully!"),
            backgroundColor: ColorsManager.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
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
                    '12 files uploaded this semester',
                    style: isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall,
                  ),
                ],
              ),
              GestureDetector(
                onTap: _isUploading ? null : _mockUploadMaterial,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isUploading ? ColorsManager.grayMedium : ColorsManager.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      if (_isUploading)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: const CircularProgressIndicator(
                            color: ColorsManager.white,
                            strokeWidth: 2,
                          ),
                        )
                      else
                        Icon(Icons.add, color: ColorsManager.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        _isUploading ? 'Uploading...' : 'Upload',
                        style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          _buildMaterialItem(context, 'Lecture 01 - Intro to Neonat...', 'Oct 12, 2023 • 2.4 MB', Icons.picture_as_pdf, ColorsManager.red),
          _buildMaterialItem(context, 'Case Study Assignment #1...', 'Oct 15, 2023 • 1.1 MB', Icons.description, ColorsManager.blue),
          _buildMaterialItem(context, 'Week 3 - Pediatric Surgery...', 'Oct 28, 2023 • 8.6 MB', Icons.play_circle_fill, ColorsManager.yellow),
          _buildMaterialItem(context, 'Clinical Rotation Schedule.x...', 'Nov 02, 2023 • 450 KB', Icons.table_chart, ColorsManager.green),
          _buildMaterialItem(context, 'Final Exam Study Guide.pdf', 'Nov 10, 2023 • 3.2 MB', Icons.picture_as_pdf, ColorsManager.red),
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