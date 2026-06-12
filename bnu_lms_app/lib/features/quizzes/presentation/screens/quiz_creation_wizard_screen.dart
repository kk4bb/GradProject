import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_grading_cubit.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../widgets/quiz_preview_step.dart';
import '../widgets/quiz_questions_step.dart';
import '../widgets/quiz_settings_step.dart';

class QuizCreationWizardScreen extends StatefulWidget {
  const QuizCreationWizardScreen({super.key});

  @override
  State<QuizCreationWizardScreen> createState() => _QuizCreationWizardScreenState();
}

class _QuizCreationWizardScreenState extends State<QuizCreationWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.animateToPage(
        _currentStep + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.animateToPage(
        _currentStep - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.white : const Color(0xFF131F24),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Quiz',
          style: isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge,
        ),
      ),
      body: BlocListener<QuizGradingCubit, QuizGradingState>(
        listener: (context, state) {
          if (state is QuizGradingSuccess && state.message.contains('Draft')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: const Color(0xFF26C6DA)),
            );
          } else if (state is QuizGradingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: ColorsManager.red),
            );
          }
        },
        child: Column(
        children: [
          _buildStepper(isLight),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe to force using buttons
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                QuizSettingsStep(onNext: _nextStep),
                QuizQuestionsStep(onNext: _nextStep, onBack: _previousStep),
                QuizPreviewStep(onBack: _previousStep),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildStepper(bool isLight) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLight ? ColorsManager.grayMedium : ColorsManager.grayDark,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepNode(0, '1', 'SETTINGS', isLight),
          _buildStepDivider(isLight),
          _buildStepNode(1, '2', 'QUESTIONS', isLight),
          _buildStepDivider(isLight),
          _buildStepNode(2, '3', 'PREVIEW', isLight),
        ],
      ),
    );
  }

  Widget _buildStepNode(int stepIndex, String number, String label, bool isLight) {
    bool isActive = _currentStep >= stepIndex;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF26C6DA) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? const Color(0xFF26C6DA) : ColorsManager.grayMedium,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? ColorsManager.white : ColorsManager.grayMedium,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? (isLight ? ColorsManager.black : ColorsManager.white) : ColorsManager.grayMedium,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isLight) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16), // align with circles
        color: isLight ? ColorsManager.grayMedium : ColorsManager.grayDark,
      ),
    );
  }
}
