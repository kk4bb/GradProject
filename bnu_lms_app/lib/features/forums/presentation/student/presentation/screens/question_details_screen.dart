import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../widgets/fourms_details/forum_answer_card.dart';
import '../widgets/fourms_details/forum_answer_input.dart';
import '../widgets/fourms_details/forum_question_card.dart';

import '../../../../domain/entities/forum_entities.dart';
import '../../../../presentation/cubit/forums_cubit.dart';
import '../../../../presentation/cubit/forums_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final DiscussionEntity discussion;

  const QuestionDetailsScreen({
    required this.discussion,
    super.key,
  });

  @override
  State<QuestionDetailsScreen> createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  final TextEditingController answerController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ForumsCubit>().initSignalR());
    Future.microtask(() {
      if (mounted) {
        context.read<ForumsCubit>().loadPosts(widget.discussion.id, widget.discussion.title);
      }
    });
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
          'Question Details',
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
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
                  Builder(
                    builder: (context) {
                      String author = widget.discussion.authorName ?? 'Unknown';
                      String timeAgo = 'Just now';
                      if (widget.discussion.createdAt != null) {
                        final diff = DateTime.now().difference(widget.discussion.createdAt!);
                        if (diff.inDays > 0) { timeAgo = '${diff.inDays}d ago'; }
                        else if (diff.inHours > 0) { timeAgo = '${diff.inHours}h ago'; }
                        else if (diff.inMinutes > 0) { timeAgo = '${diff.inMinutes}m ago'; }
                      }

                      return ForumQuestionCard(
                        authorName: author,
                        authorAvatarUrl: widget.discussion.authorAvatarUrl,
                        timeAgo: timeAgo,
                        questionTitle: widget.discussion.title,
                        questionBody: widget.discussion.content ?? 'No content provided.',
                        votes: 0,
                        commentsCount: widget.discussion.postCount,
                        status: widget.discussion.status,
                        statusColor: widget.discussion.status == 'RESOLVED' ? ColorsManager.green : (widget.discussion.status == 'CLOSED' ? ColorsManager.grayMedium : ColorsManager.blue),
                        isPreview: false,
                      );
                    }
                  ),
                  BlocBuilder<ForumsCubit, ForumsState>(
                    builder: (context, state) {
                      if (state is ForumsLoading || state is ForumsActionLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is PostsLoaded) {
                        return Column(
                          children: [
                            _buildAnswersHeader(isLight, state.posts.length),
                            _buildAnswersList(isLight, state.posts),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          ForumAnswerInput(
            controller: answerController,
            focusNode: _replyFocusNode,
            onSubmit: () {
              final text = answerController.text.trim();
              if (text.isNotEmpty) {
                context.read<ForumsCubit>().createPost(
                  widget.discussion.id,
                  widget.discussion.title,
                  text,
                );
                answerController.clear();
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersHeader(bool isLight, int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Text(
            'ALL ANSWERS ($count)',
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

  Widget _buildAnswersList(bool isLight, List<PostEntity> posts) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: posts.map((post) {
          String postTimeAgo = 'Just now';
          if (post.createdAt != null) {
            final diff = DateTime.now().difference(post.createdAt!);
            if (diff.inDays > 0) { postTimeAgo = '${diff.inDays}d ago'; }
            else if (diff.inHours > 0) { postTimeAgo = '${diff.inHours}h ago'; }
            else if (diff.inMinutes > 0) { postTimeAgo = '${diff.inMinutes}m ago'; }
          }
          return ForumAnswerCard(
            authorName: post.authorName,
            authorAvatarUrl: post.authorAvatarUrl,
            role: 'Student', // Can be derived dynamically later
            timestamp: postTimeAgo,
            answerText: post.content,
            votes: post.votes,
            isTopRated: post.isCorrect,
            approvedByRole: post.approvedByRole,
            onUpvote: () => context.read<ForumsCubit>().votePost(post.id, true, widget.discussion.id, widget.discussion.title),
            onDownvote: () => context.read<ForumsCubit>().votePost(post.id, false, widget.discussion.id, widget.discussion.title),
            onReplyTap: () {
              answerController.text = '@${post.authorName} ';
              _replyFocusNode.requestFocus();
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    answerController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }
}