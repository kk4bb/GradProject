import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_grading_cubit.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class QuizSettingsStep extends StatefulWidget {
  final VoidCallback onNext;

  const QuizSettingsStep({super.key, required this.onNext});

  @override
  State<QuizSettingsStep> createState() => _QuizSettingsStepState();
}

class _QuizSettingsStepState extends State<QuizSettingsStep> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<QuizGradingCubit>();
    _titleController = TextEditingController(text: cubit.creationTitle);
    _descriptionController = TextEditingController(text: cubit.creationDescription);
    
    // Format dates if they exist
    _startDateController = TextEditingController(
      text: cubit.creationStartDate != null 
          ? "${cubit.creationStartDate!.year}-${cubit.creationStartDate!.month.toString().padLeft(2, '0')}-${cubit.creationStartDate!.day.toString().padLeft(2, '0')} ${cubit.creationStartDate!.hour.toString().padLeft(2, '0')}:${cubit.creationStartDate!.minute.toString().padLeft(2, '0')}"
          : ""
    );
    _endDateController = TextEditingController(
      text: cubit.creationEndDate != null 
          ? "${cubit.creationEndDate!.year}-${cubit.creationEndDate!.month.toString().padLeft(2, '0')}-${cubit.creationEndDate!.day.toString().padLeft(2, '0')} ${cubit.creationEndDate!.hour.toString().padLeft(2, '0')}:${cubit.creationEndDate!.minute.toString().padLeft(2, '0')}"
          : ""
    );
    _durationController = TextEditingController(text: cubit.creationDuration);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF26C6DA), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Provider.of<ThemeProvider>(context, listen: false).isLightTheme() ? Colors.black : Colors.white, // body text color
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Provider.of<ThemeProvider>(context, listen: false).isLightTheme() ? Colors.white : const Color(0xFF1A2A30),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: const Color(0xFF26C6DA),
                onSurface: Provider.of<ThemeProvider>(context, listen: false).isLightTheme() ? Colors.black : Colors.white,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Provider.of<ThemeProvider>(context, listen: false).isLightTheme() ? Colors.white : const Color(0xFF1A2A30),
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          controller.text = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
        });
      }
    }
  }

  void _handleNext() {
    // Parse the date strings back to DateTime objects
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 1));
    
    if (_startDateController.text.isNotEmpty) {
      try {
        startDate = DateTime.parse(_startDateController.text.replaceFirst(' ', 'T'));
      } catch (_) {}
    }
    if (_endDateController.text.isNotEmpty) {
      try {
        endDate = DateTime.parse(_endDateController.text.replaceFirst(' ', 'T'));
      } catch (_) {}
    }

    // Update Cubit with basic settings before moving to questions
    context.read<QuizGradingCubit>().updateQuizSettings(
      _titleController.text.trim(), 
      _descriptionController.text.trim(),
      _durationController.text.trim(),
      startDate,
      endDate,
    );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    // final surfaceColor = isLight ? ColorsManager.white : const Color(0xFF1A2A30);
    final inputFillColor = isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24);

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Information',
            style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
          ),
          SizedBox(height: 16),
          _buildTextField(isLight, inputFillColor, 'Quiz Title', 'e.g. Midterm Assessment', controller: _titleController),
          SizedBox(height: 16),
          _buildTextField(isLight, inputFillColor, 'Description', 'Provide instructions for the students...', maxLines: 3, controller: _descriptionController),
          SizedBox(height: 16),
          _buildDropdown(isLight, inputFillColor, 'Associated Course', ['Advanced Software Engineering', 'UI/UX Design']),

          SizedBox(height: 32),
          Text(
            'Schedule',
            style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(isLight, inputFillColor, 'Start Date', 'Select date', icon: Icons.calendar_today_outlined, controller: _startDateController, readOnly: true, onTap: () => _selectDateTime(_startDateController))),
              SizedBox(width: 16),
              Expanded(child: _buildTextField(isLight, inputFillColor, 'End Date', 'Select date', icon: Icons.calendar_today_outlined, controller: _endDateController, readOnly: true, onTap: () => _selectDateTime(_endDateController))),
            ],
          ),

          SizedBox(height: 32),
          Text(
            'Restrictions',
            style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(isLight, inputFillColor, 'Duration', '60', suffix: 'MINS', controller: _durationController)),
              SizedBox(width: 16),
              Expanded(child: _buildDropdown(isLight, inputFillColor, 'Allowed Attempts', ['1 Attempt', '2 Attempts', 'Unlimited'])),
            ],
          ),

          SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<QuizGradingCubit, QuizGradingState>(
                builder: (context, state) {
                  final isLoading = state is QuizGradingLoading;
                  return OutlinedButton(
                    onPressed: isLoading ? null : () {
                      DateTime startDate = DateTime.now();
                      DateTime endDate = DateTime.now().add(const Duration(days: 1));
                      
                      if (_startDateController.text.isNotEmpty) {
                        try { startDate = DateTime.parse(_startDateController.text.replaceFirst(' ', 'T')); } catch (_) {}
                      }
                      if (_endDateController.text.isNotEmpty) {
                        try { endDate = DateTime.parse(_endDateController.text.replaceFirst(' ', 'T')); } catch (_) {}
                      }

                      // Update settings first, then save draft
                      context.read<QuizGradingCubit>().updateQuizSettings(
                        _titleController.text.trim(), 
                        _descriptionController.text.trim(),
                        _durationController.text.trim(),
                        startDate,
                        endDate,
                      );
                      context.read<QuizGradingCubit>().saveDraft();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isLight ? ColorsManager.grayMedium : ColorsManager.grayDark),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading 
                      ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: isLight ? ColorsManager.black : ColorsManager.white))
                      : Text(
                          'Save as Draft',
                          style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.bold),
                        ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26C6DA),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    Text(
                      'Add Questions',
                      style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: ColorsManager.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(bool isLight, Color fillColor, String label, String hint, {int maxLines = 1, IconData? icon, String? suffix, TextEditingController? controller, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
            filled: true,
            fillColor: fillColor,
            suffixIcon: icon != null ? Icon(icon, color: ColorsManager.grayMedium, size: 20) : null,
            suffixText: suffix,
            suffixStyle: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium, fontWeight: FontWeight.bold),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF26C6DA), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(bool isLight, Color fillColor, String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: items.first,
              icon: Icon(Icons.keyboard_arrow_down, color: ColorsManager.grayMedium),
              dropdownColor: isLight ? ColorsManager.white : const Color(0xFF1A2A30),
              style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
              onChanged: (String? newValue) {},
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
