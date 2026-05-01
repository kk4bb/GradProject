import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/network/repositories/forum_repository.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../data/models/forum_model.dart';
import '../widgets/fourms_details/forum_answer_card.dart';
import '../widgets/fourms_details/forum_answer_input.dart';
import '../widgets/fourms_details/forum_question_card.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final int discussionId;
  final String discussionTitle;

  const QuestionDetailsScreen({
    required this.discussionId,
    required this.discussionTitle,
    super.key,
  });

  @override
  State<QuestionDetailsScreen> createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  final TextEditingController postController = TextEditingController();
  final ForumRepository _forumRepository = ForumRepository();
  late Future<List<Post>> _postsFuture;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _postsFuture = _forumRepository.getPosts(widget.discussionId);
  }

  Future<void> _submitPost() async {
    if (postController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _forumRepository.createPost(widget.discussionId, postController.text.trim());
      postController.clear();
      setState(() {
        _postsFuture = _forumRepository.getPosts(widget.discussionId);
      });
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
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
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.discussionTitle,
          style: isLight ? AppLightTextStyles.headlineSmall : AppDarkTextStyles.headlineSmall,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final posts = snapshot.data!;
                if (posts.isEmpty) {
                  return const Center(child: Text('No posts yet. Be the first to start the conversation!'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ForumQuestionCard(
                          authorName: post.authorName,
                          timeAgo: '', // Backend doesn't provide time yet
                          questionTitle: '',
                          questionBody: post.content,
                          votes: 0,
                          commentsCount: post.commentCount,
                          status: 'POST',
                          statusColor: ColorsManager.blue,
                          isPreview: false,
                        ),
                        if (post.comments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Column(
                              children: post.comments.map((comment) {
                                return ForumAnswerCard(
                                  authorName: comment.authorName,
                                  role: 'Comment',
                                  timestamp: '',
                                  answerText: comment.content,
                                  votes: 0,
                                  isTopRated: false,
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          if (_isSubmitting)
            const LinearProgressIndicator(),
          ForumAnswerInput(
            controller: postController,
            onSubmit: _isSubmitting ? () {} : _submitPost,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }
}