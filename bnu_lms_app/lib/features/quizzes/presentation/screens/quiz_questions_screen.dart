// lib/features/quizzes/presentation/screens/quiz_questions_screen.dart

import 'package:flutter/material.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../widgets/quiz/quiz_bottom_nav_widget.dart';
import '../widgets/quiz/quiz_header_widget.dart';
import '../widgets/quiz/quiz_question_body_widget.dart';

// ─── Temporary data model (replace with domain entity later) ─────────────────
class _QuizQuestion {
  final String text;
  final String? imageUrl;
  final List<String> options;
  final int correctIndex;

  const _QuizQuestion({
    required this.text,
    required this.options,
    required this.correctIndex,
    this.imageUrl,
  });
}

class QuizQuestionsScreen extends StatefulWidget {
  const QuizQuestionsScreen({super.key});

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  // ── Sample Data ─────────────────────────────────────────────────────────────
  final List<_QuizQuestion> _questions = const [
    _QuizQuestion(
      text: 'What is the primary function of the mitochondria in a cell?',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Mitochondria%2C_mammalian_lung_-_TEM_%282%29.jpg/320px-Mitochondria%2C_mammalian_lung_-_TEM_%282%29.jpg',
      options: [
        'Protein synthesis and folding',
        'Energy production via ATP',
        'DNA replication and storage',
        'Lipid membrane formation',
      ],
      correctIndex: 1,
    ),
    _QuizQuestion(
      text: 'Which data structure uses LIFO (Last In, First Out) principle?',
      options: [
        'Queue',
        'Linked List',
        'Stack',
        'Binary Tree',
      ],
      correctIndex: 2,
    ),
    _QuizQuestion(
      text: 'What is the time complexity of binary search?',
      options: [
        'O(n)',
        'O(n²)',
        'O(log n)',
        'O(1)',
      ],
      correctIndex: 2,
    ),
  ];

  int _currentIndex = 0;
  final Map<int, int> _answers = {}; // questionIndex → selectedOptionIndex

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  String get _timeString => "--:--";

  double get _timerProgress  => 1.0;

  double get _questionProgress => (_currentIndex + 1) / _questions.length;

  bool get _isFirstQuestion => _currentIndex == 0;
  bool get _isLastQuestion  => _currentIndex == _questions.length - 1;

  void _onOptionSelected(int optionIndex) =>
      setState(() => _answers[_currentIndex] = optionIndex);

  void _goNext() {
    if (_isLastQuestion) {
      _submitQuiz();
      return;
    }
    setState(() => _currentIndex++);
  }

  void _goPrevious() {
    if (!_isFirstQuestion) setState(() => _currentIndex--);
  }

  void _submitQuiz() {
    // TODO: emit cubit event with answers map → navigate to results
    Navigator.pop(context);
  }

  // ── Build ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: ColorsManager.lightBackground,

      // ── Header ─────────────────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SafeArea(
          child: QuizHeaderWidget(
            currentQuestion: _currentIndex + 1,
            totalQuestions:  _questions.length,
            timeRemaining:   _timeString,
            progress:        _timerProgress,
            questionProgress: _questionProgress,
            onClose: () => _showExitDialog(context),
          ),
        ),
      ),

      // ── Scrollable Body ─────────────────────────────────────────────────────
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: QuizQuestionBodyWidget(
          key: ValueKey(_currentIndex),
          questionText: question.text,
          imageUrl: question.imageUrl,
          options: question.options,
          selectedIndex: _answers[_currentIndex],
          onOptionSelected: _onOptionSelected,
        ),
      ),

      // ── Bottom Nav ──────────────────────────────────────────────────────────
      bottomNavigationBar: QuizBottomNavWidget(
        onPrevious:      _goPrevious,
        onNext:          _goNext,
        isFirstQuestion: _isFirstQuestion,
        isLastQuestion:  _isLastQuestion,
      ),
    );
  }

  // ── Exit Confirmation Dialog ─────────────────────────────────────────────────
  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Exit Quiz?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Text(
          'Your progress will be lost. Are you sure?',
          style: TextStyle(fontSize: 14, color: ColorsManager.grayDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close quiz
            },
            child: Text('Exit', style: TextStyle(color: ColorsManager.red)),
          ),
        ],
      ),
    );
  }
}
