import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../manager/instructor/assignments_cubit.dart';
import '../manager/instructor/assignments_state.dart';

class CreateAssignmentScreen extends StatefulWidget {
  final int courseId;

  const CreateAssignmentScreen({super.key, required this.courseId});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return BlocConsumer<AssignmentsCubit, AssignmentsState>(
      listener: (context, state) {
        state.maybeWhen(
          created: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Assignment Published!'), backgroundColor: ColorsManager.green),
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
              'New Assignment', 
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
                _buildInputField(
                  context: context,
                  label: 'Assignment Title',
                  hint: 'e.g., Midterm Project',
                  controller: _titleController,
                ),
                SizedBox(height: 16),
                _buildInputField(
                  context: context,
                  label: 'Description / Instructions',
                  hint: 'Enter details...',
                  maxLines: 4,
                  controller: _descController,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        context: context,
                        label: 'Points',
                        hint: 'e.g., 20',
                        controller: _pointsController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        context: context,
                        label: 'Due Date',
                        hint: _selectedDate == null ? 'Select Date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        isDate: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: isLight 
                                    ? const ColorScheme.light(primary: ColorsManager.blue)
                                    : const ColorScheme.dark(primary: ColorsManager.blue, surface: ColorsManager.darkSurface),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Attach Files (Optional)', 
                  style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium
                ),
                SizedBox(height: 12),
                _buildAttachArea(context),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.maybeWhen(loading: () => null, orElse: () => () {
                      context.read<AssignmentsCubit>().createAssignment(
                        courseId: widget.courseId,
                        title: _titleController.text,
                        description: _descController.text,
                        points: double.tryParse(_pointsController.text) ?? 0,
                        dueDate: _selectedDate ?? DateTime.now(),
                        filePath: _selectedFilePath,
                      );
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.blue,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: state.maybeWhen(
                      loading: () => const CircularProgressIndicator(color: Colors.white),
                      orElse: () => Text(
                        'Publish Assignment', 
                        style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: Colors.white)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required String hint,
    int maxLines = 1,
    bool isDate = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: isLight ? AppLightTextStyles.bodySmall : AppDarkTextStyles.bodySmall
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: isDate,
          onTap: onTap,
          keyboardType: keyboardType,
          style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
            filled: true,
            fillColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
            suffixIcon: isDate ? Icon(Icons.calendar_today, color: ColorsManager.blue, size: 20) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), 
              borderSide: isLight ? BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.1)) : BorderSide.none
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), 
              borderSide: isLight ? BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.1)) : BorderSide.none
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachArea(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null) {
          setState(() {
            _selectedFilePath = result.files.single.path;
            _selectedFileName = result.files.single.name;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorsManager.blue.withValues(alpha: 0.3), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.attach_file, color: ColorsManager.blue, size: 32),
            SizedBox(height: 8),
            Text(
              _selectedFileName ?? 'Tap to browse files (PDF only)', 
              style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(
                color: _selectedFileName != null ? ColorsManager.blue : null,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
