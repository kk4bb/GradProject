import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/di/injection.dart';
import '../../domain/entities/assignment_entity.dart';
import '../manager/submission/assignment_submission_cubit.dart';
import '../manager/submission/assignment_submission_state.dart';
import 'submission_success_screen.dart';

class SubmitAssignmentScreen extends StatefulWidget {
  final AssignmentEntity assignment;

  const SubmitAssignmentScreen({super.key, required this.assignment});

  @override
  State<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends State<SubmitAssignmentScreen> {
  String? _filePath;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return BlocProvider(
      create: (context) => getIt<AssignmentSubmissionCubit>(),
      child: BlocConsumer<AssignmentSubmissionCubit, AssignmentSubmissionState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SubmissionSuccessScreen()),
              );
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: ColorsManager.red),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
            appBar: AppBar(
              title: Text(
                'Submit Assignment', 
                style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: isLight ? ColorsManager.black : ColorsManager.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Upload File'),
                  SizedBox(height: 12),
                  _FileUploadArea(
                    filePath: _filePath,
                    onTap: _pickFile,
                  ),
                  SizedBox(height: 24),
                  _SectionTitle(title: 'Assignment URL (Optional)'),
                  SizedBox(height: 12),
                  _CustomTextField(
                    controller: _urlController,
                    hintText: 'https://example.com/project',
                    maxLines: 1,
                  ),
                  SizedBox(height: 24),
                  _SectionTitle(title: 'Comments (Optional)'),
                  SizedBox(height: 12),
                  _CustomTextField(
                    controller: _commentController,
                    hintText: 'Enter your comments here...',
                    maxLines: 4,
                  ),
                  SizedBox(height: 40),
                  _SubmitButton(
                    isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
                    onPressed: () {
                      context.read<AssignmentSubmissionCubit>().submitAssignment(
                        assignmentId: widget.assignment.id,
                        filePath: _filePath,
                        url: _urlController.text.isNotEmpty ? _urlController.text : null,
                        comment: _commentController.text.isNotEmpty ? _commentController.text : null,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Text(
      title, 
      style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontWeight: FontWeight.bold)
    );
  }
}

class _FileUploadArea extends StatelessWidget {
  final String? filePath;
  final VoidCallback onTap;

  const _FileUploadArea({this.filePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorsManager.blue.withValues(alpha: 0.3), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, color: ColorsManager.blue, size: 40),
            SizedBox(height: 12),
            Text(
              filePath != null ? filePath!.split('/').last : 'Tap to browse files',
              style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.blue),
            ),
            if (filePath == null)
              Text(
                'Maximum file size: 50MB',
                style: (isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall).copyWith(fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
        filled: true,
        fillColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isLight ? BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.1)) : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isLight ? BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.1)) : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.blue),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                'Submit Now', 
                style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: Colors.white)
              ),
      ),
    );
  }
}
