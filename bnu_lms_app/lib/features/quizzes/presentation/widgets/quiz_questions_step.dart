import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_grading_cubit.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class QuizQuestionsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const QuizQuestionsStep({super.key, required this.onNext, required this.onBack});

  @override
  State<QuizQuestionsStep> createState() => _QuizQuestionsStepState();
}

class _QuizQuestionsStepState extends State<QuizQuestionsStep> {
  int _correctOptionIndex = 0;
  String _questionType = 'Multiple Choice';
  final TextEditingController _questionTextController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController(text: '10');
  String? _imagePath;
  
  // Options controllers
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _questionTextController.dispose();
    _pointsController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveQuestion() {
    if (_questionTextController.text.trim().isEmpty) return;
    
    final cubit = context.read<QuizGradingCubit>();
    
    List<Map<String, dynamic>> options = [];
    if (_questionType != 'Open-ended / Essay') {
      for (int i = 0; i < _optionControllers.length; i++) {
        if (_optionControllers[i].text.trim().isNotEmpty) {
          options.add({
            'text': _optionControllers[i].text.trim(),
            'isCorrect': _correctOptionIndex == i,
          });
        }
      }
    }

    cubit.addQuestion({
      'text': _questionTextController.text.trim(),
      'type': _questionType,
      'points': int.tryParse(_pointsController.text) ?? 1,
      'timeLimit': 0, // Fallback since UI field removed
      'isEssay': _questionType == 'Open-ended / Essay',
      'options': options,
      'imagePath': _imagePath,
    });

    // Clear form
    _questionTextController.clear();
    _imagePath = null;
    for (var controller in _optionControllers) {
      controller.clear();
    }
    setState(() {
      _correctOptionIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question saved!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final inputFillColor = isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24);
    final cubit = context.watch<QuizGradingCubit>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddedQuestionsList(cubit, isLight, inputFillColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Question',
                style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _questionType,
                    icon: Icon(Icons.arrow_drop_down, color: const Color(0xFF26C6DA), size: 20),
                    dropdownColor: isLight ? ColorsManager.white : const Color(0xFF1A2A30),
                    style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(
                      color: const Color(0xFF26C6DA),
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _questionType = newValue;
                        });
                      }
                    },
                    items: ['Multiple Choice', 'True/False', 'Open-ended / Essay']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Question Text Area
          TextField(
            controller: _questionTextController,
            maxLines: 4,
            style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter your question here...',
              hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
              filled: true,
              fillColor: inputFillColor,
              contentPadding: EdgeInsets.all(16),
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
          SizedBox(height: 16),

          // Media Upload
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: _imagePath != null ? 0 : 24),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : const Color(0xFF131F24),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorsManager.grayMedium.withValues(alpha: 0.5),
                  style: BorderStyle.solid, 
                ),
              ),
              child: _imagePath != null
                  ? Image.file(
                      File(_imagePath!),
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Column(
                        children: [
                          Icon(Icons.image_outlined, color: ColorsManager.grayMedium, size: 28),
                          SizedBox(height: 8),
                          Text(
                            'Tap to add an image',
                            style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium),
                          ),
                        ],
                      ),
                    ),
            ),
          ),

          SizedBox(height: 32),
          _buildTextField(isLight, inputFillColor, 'Points', '10', controller: _pointsController),

          SizedBox(height: 32),
          
          if (_questionType != 'Open-ended / Essay') ...[
            Text(
              'Answer Options',
              style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
            ),
            SizedBox(height: 16),

            // Options List
            RadioGroup<int>(
              groupValue: _correctOptionIndex,
              onChanged: (value) {
                setState(() {
                  _correctOptionIndex = value!;
                });
              },
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _optionControllers.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final letter = String.fromCharCode(65 + index); // A, B, C, D...
                  return _buildOptionItem(isLight, inputFillColor, index, letter, 'Enter option text', controller: _optionControllers[index]);
                },
              ),
            ),
            if (_questionType == 'Multiple Choice') ...[
              SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _optionControllers.add(TextEditingController());
                  });
                },
                icon: Icon(Icons.add, color: const Color(0xFF26C6DA), size: 18),
                label: Text(
                  'Add Option',
                  style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(
                    color: const Color(0xFF26C6DA),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ] else ...[
             // Essay placeholder
             Container(
               padding: EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: inputFillColor,
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.5)),
               ),
               child: Text(
                 'Students will be provided a rich text editor to write their essay response. This question will require manual grading.',
                 style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
               ),
             ),
          ],

          SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: widget.onBack,
                child: Text(
                  'Back',
                  style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayDark, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _saveQuestion,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF26C6DA)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Save Question',
                      style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: const Color(0xFF26C6DA), fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26C6DA),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Next',
                      style: AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(bool isLight, Color fillColor, String label, String hint, {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
            filled: true,
            fillColor: fillColor,
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

  Widget _buildOptionItem(bool isLight, Color fillColor, int index, String letter, String hint, {TextEditingController? controller}) {
    bool isSelected = _correctOptionIndex == index;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF26C6DA) : fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: isSelected ? ColorsManager.white : (isLight ? ColorsManager.black : ColorsManager.white),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.grayMedium),
              filled: true,
              fillColor: fillColor,
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
        ),
        SizedBox(width: 8),
        Radio<int>(
          value: index,
          activeColor: const Color(0xFF26C6DA),
        ),
        if (_optionControllers.length > 2)
          IconButton(
            icon: Icon(Icons.delete_outline, color: ColorsManager.red, size: 20),
            onPressed: () {
              setState(() {
                if (_correctOptionIndex == index) {
                  _correctOptionIndex = 0;
                } else if (_correctOptionIndex > index) {
                  _correctOptionIndex--;
                }
                _optionControllers[index].dispose();
                _optionControllers.removeAt(index);
              });
            },
          ),
      ],
    );
  }

  Widget _buildAddedQuestionsList(QuizGradingCubit cubit, bool isLight, Color inputFillColor) {
    if (cubit.creationQuestions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Added Questions (${cubit.creationQuestions.length})',
          style: isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium,
        ),
        SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cubit.creationQuestions.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final q = cubit.creationQuestions[index];
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: inputFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${q['text']}',
                          style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${q['points']} Points | ${q['type']}',
                          style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.grayMedium),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: ColorsManager.blue, size: 20),
                    onPressed: () => _editQuestion(index, q, cubit),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: ColorsManager.red, size: 20),
                    onPressed: () {
                      setState(() {
                        cubit.removeQuestion(index);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 32),
        Divider(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
        SizedBox(height: 32),
      ],
    );
  }

  void _editQuestion(int index, Map<String, dynamic> q, QuizGradingCubit cubit) {
    cubit.removeQuestion(index);
    
    setState(() {
      _questionType = q['type'] ?? 'Multiple Choice';
      _questionTextController.text = q['text'] ?? '';
      _pointsController.text = (q['points'] ?? 10).toString();
      _imagePath = q['imagePath'];
      
      final options = q['options'] as List<Map<String, dynamic>>? ?? [];
      
      for (var c in _optionControllers) {
        c.dispose();
      }
      _optionControllers.clear();
      
      _correctOptionIndex = 0;
      
      if (_questionType != 'Open-ended / Essay') {
        for (int i = 0; i < options.length; i++) {
          _optionControllers.add(TextEditingController(text: options[i]['text']));
          if (options[i]['isCorrect'] == true) {
            _correctOptionIndex = i;
          }
        }
        while (_optionControllers.length < 2) {
           _optionControllers.add(TextEditingController());
        }
      } else {
        _optionControllers.add(TextEditingController());
        _optionControllers.add(TextEditingController());
        _optionControllers.add(TextEditingController());
        _optionControllers.add(TextEditingController());
      }
    });
  }
}
