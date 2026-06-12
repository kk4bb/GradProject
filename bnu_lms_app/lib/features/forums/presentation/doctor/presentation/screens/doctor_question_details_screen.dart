import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../student/presentation/widgets/fourms_details/forum_answer_input.dart';
import '../../../student/presentation/widgets/fourms_details/forum_question_card.dart';
import '../widgets/doctor_forum_answer_card.dart';

import '../../../../domain/entities/forum_entities.dart';
import '../../../../presentation/cubit/forums_cubit.dart';
import '../../../../presentation/cubit/forums_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorQuestionDetailsScreen extends StatefulWidget {
  final DiscussionEntity discussion;

  const DoctorQuestionDetailsScreen({
    required this.discussion,
    super.key,
  });

  @override
  State<DoctorQuestionDetailsScreen> createState() => _DoctorQuestionDetailsScreenState();
}

class _DoctorQuestionDetailsScreenState extends State<DoctorQuestionDetailsScreen> {
  final TextEditingController answerController = TextEditingController();

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
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Question Details', style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Question View
                  _buildFullQuestion(isLight),
                  SizedBox(height: 24),

                  BlocBuilder<ForumsCubit, ForumsState>(
                    builder: (context, state) {
                      if (state is ForumsLoading || state is ForumsActionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is PostsLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STUDENT RESPONSES (${state.posts.length})',
                              style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                            SizedBox(height: 12),
                            // Student Answers List
                            ...state.posts.map((post) {
                                String postTimeAgo = 'Just now';
                                if (post.createdAt != null) {
                                  final diff = DateTime.now().difference(post.createdAt!);
                                  if (diff.inDays > 0) { postTimeAgo = '${diff.inDays}d ago'; }
                                  else if (diff.inHours > 0) { postTimeAgo = '${diff.inHours}h ago'; }
                                  else if (diff.inMinutes > 0) { postTimeAgo = '${diff.inMinutes}m ago'; }
                                }
                                return DoctorForumAnswerCard(
                                  authorName: post.authorName,
                                  authorAvatarUrl: post.authorAvatarUrl,
                                  timeAgo: postTimeAgo,
                                  answerText: post.content,
                                  isCorrect: post.isCorrect,
                                  votes: post.votes,
                                  approvedByRole: post.approvedByRole,
                                  onMarkCorrect: () => context.read<ForumsCubit>().markAsCorrect(post.id, widget.discussion.id, widget.discussion.title),
                                  onUpvote: () => context.read<ForumsCubit>().votePost(post.id, true, widget.discussion.id, widget.discussion.title),
                                  onDownvote: () => context.read<ForumsCubit>().votePost(post.id, false, widget.discussion.id, widget.discussion.title),
                                );
                              }),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          ForumAnswerInput(
            controller: answerController,
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

  Widget _buildFullQuestion(bool isLight) {
    final author = widget.discussion.authorName ?? 'Unknown';
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



  // Widget _buildTag(String text, Color color) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withValues(alpha: 0.3))),
  //     child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
  //   );
  // }
}