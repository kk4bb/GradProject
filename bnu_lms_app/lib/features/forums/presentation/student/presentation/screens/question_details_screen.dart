import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../widgets/fourms_details/forum_answer_card.dart';
import '../widgets/fourms_details/forum_answer_input.dart';
import '../widgets/fourms_details/forum_question_card.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> questionData;

  const QuestionDetailsScreen({
    required this.questionData,
    super.key,
  });

  @override
  State<QuestionDetailsScreen> createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  final TextEditingController answerController = TextEditingController();

  final List<Map<String, dynamic>> answers = [
    {
      'author': 'Dr. Sarah Jenkins',
      'role': 'VERIFIED SPECIALIST',
      'timestamp': 'Answered 1w ago',
      'answer': 'For a Poisson distribution, a unique property is that the variance is equal to the mean (λ). If you have the parameter λ, then Var(X) = λ.\n\nThis simplifies many calculations in stochastic modeling!',
      'votes': 142,
      'isTopRated': true, // Doctor Approved
    },
    {
      'author': 'Fatima Ali',
      'role': 'Student',
      'timestamp': 'Answered 5d ago',
      'answer': 'I think you just need to look at the expected value formula. It\'s basically the same steps. λ is the magic number here!',
      'votes': 8,
      'isTopRated': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Question Details',
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Question Card (isPreview = false)
                  ForumQuestionCard(
                    authorName: widget.questionData['author'],
                    timeAgo: widget.questionData['timeAgo'],
                    questionTitle: widget.questionData['title'],
                    questionBody: widget.questionData['question'],
                    votes: widget.questionData['votes'],
                    commentsCount: widget.questionData['commentsCount'],
                    status: widget.questionData['status'],
                    statusColor: widget.questionData['statusColor'],
                    isPreview: false,
                  ),
                  _buildAnswersHeader(isLight),
                  _buildAnswersList(isLight),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          ForumAnswerInput(
            controller: answerController,
            onSubmit: () {
              // Handle submit
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersHeader(bool isLight) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Text(
            'ALL ANSWERS (${answers.length})',
            style: isLight
                ? AppLightTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, color: ColorsManager.grayDark)
                : AppDarkTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, color: ColorsManager.darkTextSecondary),
          ),
          Spacer(),
          Text(
            'Sort by: ',
            style: TextStyle(fontSize: 13, color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary),
          ),
          Text(
            'Highest score',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersList(bool isLight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: answers.map((answer) {
          return ForumAnswerCard(
            authorName: answer['author'],
            role: answer['role'],
            timestamp: answer['timestamp'],
            answerText: answer['answer'],
            votes: answer['votes'],
            isTopRated: answer['isTopRated'],
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}