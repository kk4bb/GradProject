import 'package:bnu_lms_app/shared/network/repositories/forum_repository.dart';
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
  final int discussionId;

  const QuestionDetailsScreen({
    required this.questionData,
    required this.discussionId,
    super.key,
  });

  @override
  State<QuestionDetailsScreen> createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  final TextEditingController answerController = TextEditingController();
  final ForumRepository _forumRepository = ForumRepository();
  bool _isPosting = false;

  final List<Map<String, dynamic>> answers = [
    // ... existing mock data
  ];

  Future<void> _postAnswer() async {
    if (answerController.text.isEmpty) return;

    setState(() => _isPosting = true);

    try {
      await _forumRepository.createPost(
        widget.discussionId,
        answerController.text,
      );
      answerController.clear();
      // Optionally refresh answers list here
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Answer posted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post answer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        // ... app bar code
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
          _isPosting
              ? const Center(child: CircularProgressIndicator())
              : ForumAnswerInput(
            controller: answerController,
            onSubmit: _postAnswer,
          ),
        ],
      ),
    );
  }

  // ... _buildAnswersHeader, _buildAnswersList, dispose
}