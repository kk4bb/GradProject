import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/use_cases/update_quiz_use_case.dart';
import '../cubit/quiz_list_cubit.dart';

class EditQuizScreen extends StatefulWidget {
  final QuizEntity quiz;

  const EditQuizScreen({super.key, required this.quiz});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz.title);
    _descriptionController = TextEditingController(text: widget.quiz.description);
    _durationController = TextEditingController(text: widget.quiz.durationMinutes.toString());
    _startDate = widget.quiz.startDate;
    _endDate = widget.quiz.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (time != null) {
        setState(() {
          final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          if (isStart) {
            _startDate = newDateTime;
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  Future<void> _updateQuiz() async {
    setState(() => _isLoading = true);
    final useCase = getIt<UpdateQuizUseCase>();
    
    final updatedQuiz = QuizEntity(
      id: widget.quiz.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      courseId: widget.quiz.courseId,
      areGradesPublished: widget.quiz.areGradesPublished,
      isAutoGraded: widget.quiz.isAutoGraded,
      startDate: _startDate,
      endDate: _endDate,
      durationMinutes: int.tryParse(_durationController.text) ?? widget.quiz.durationMinutes,
      questionCount: widget.quiz.questionCount,
    );

    final result = await useCase(widget.quiz.id, updatedQuiz);
    
    if (mounted) {
      setState(() => _isLoading = false);
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message), backgroundColor: Colors.red));
        },
        (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz updated successfully!'), backgroundColor: Colors.green));
          // Refresh list
          context.read<QuizListCubit>().loadQuizzes(widget.quiz.courseId);
          Navigator.pop(context);
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final inputFillColor = isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz', style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium),
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        iconTheme: IconThemeData(color: isLight ? ColorsManager.black : ColorsManager.white),
      ),
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(isLight, inputFillColor, 'Quiz Title', _titleController),
            SizedBox(height: 16),
            _buildTextField(isLight, inputFillColor, 'Description', _descriptionController, maxLines: 3),
            SizedBox(height: 16),
            _buildTextField(isLight, inputFillColor, 'Duration (Mins)', _durationController, isNumber: true),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDateTime(true),
                    child: _buildReadOnlyField(isLight, inputFillColor, 'Start Date', _startDate.toString().substring(0, 16)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDateTime(false),
                    child: _buildReadOnlyField(isLight, inputFillColor, 'End Date', _endDate.toString().substring(0, 16)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26C6DA),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Changes', style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(bool isLight, Color fillColor, String label, TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF26C6DA))),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(bool isLight, Color fillColor, String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: fillColor, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text, 
                  style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.calendar_today, size: 16, color: ColorsManager.grayMedium),
            ],
          ),
        ),
      ],
    );
  }
}
