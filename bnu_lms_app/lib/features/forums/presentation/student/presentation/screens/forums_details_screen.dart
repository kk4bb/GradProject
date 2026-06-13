import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/di/injection.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../data/remote/forums_remote_data_source.dart';
import '../../../../domain/entities/forum_entities.dart';
import '../../../../presentation/cubit/forums_cubit.dart';
import '../../../../presentation/cubit/forums_state.dart';
import '../../../../presentation/widgets/create_post_dialog.dart';
import '../widgets/fourms_details/forum_question_card.dart';
import '../../../../../../shared/services/signalr_service.dart';
import 'question_details_screen.dart';

class ForumsDetailsScreen extends StatelessWidget {
  final String forumTitle;
  final int courseId;

  const ForumsDetailsScreen({
    required this.forumTitle,
    this.courseId = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ForumsCubit(ForumsRemoteDataSourceImpl(getIt<Dio>()), getIt<SignalRService>());
        if (courseId > 0) cubit.loadDiscussions(courseId);
        return cubit;
      },
      child: _ForumsDetailsBody(forumTitle: forumTitle, courseId: courseId),
    );
  }
}

class _ForumsDetailsBody extends StatefulWidget {
  final String forumTitle;
  final int courseId;

  const _ForumsDetailsBody({required this.forumTitle, required this.courseId});

  @override
  State<_ForumsDetailsBody> createState() => _ForumsDetailsBodyState();
}

class _ForumsDetailsBodyState extends State<_ForumsDetailsBody> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ForumsCubit>().initSignalR());
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.forumTitle,
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar — kept intact
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.white),
                decoration: InputDecoration(
                  hintText: 'Search questions...',
                  hintStyle: TextStyle(color: ColorsManager.grayMedium),
                  prefixIcon: Icon(Icons.search, color: ColorsManager.grayMedium),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Dynamic feed
          Expanded(
            child: widget.courseId <= 0
                ? Center(
                    child: Text(
                      'Please select a course to view its forum.',
                      style: TextStyle(
                        color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : BlocBuilder<ForumsCubit, ForumsState>(
                    builder: (context, state) {
                      if (state is ForumsLoading || state is ForumsActionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is ForumsError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: ColorsManager.red, size: 40),
                              const SizedBox(height: 12),
                              Text(state.message,
                                  style: TextStyle(color: ColorsManager.red, fontSize: 13),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: () => context.read<ForumsCubit>().loadDiscussions(widget.courseId),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is DiscussionsLoaded || state.discussions.isNotEmpty) {
                        if (state.discussions.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'No discussions yet. Be the first to start one!',
                                style: TextStyle(
                                  color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        final filteredDiscussions = state.discussions
                            .where((d) => d.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                            .toList();

                        return RefreshIndicator(
                          onRefresh: () => context.read<ForumsCubit>().loadDiscussions(widget.courseId),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: filteredDiscussions.length,
                            itemBuilder: (context, index) {
                              final d = filteredDiscussions[index];
                              return _DiscussionTile(discussion: d, isLight: isLight);
                            },
                          ),
                        );
                      }

                      if (state is PostsLoaded) {
                        if (state.posts.isEmpty) {
                          return Center(
                            child: Text(
                              'No posts in this discussion yet.',
                              style: TextStyle(
                                color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () => context.read<ForumsCubit>().loadPosts(state.discussionId, state.discussionTitle),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: state.posts.length,
                            itemBuilder: (context, index) {
                              final p = state.posts[index];
                              String timeAgo = 'Just now';
                              if (p.createdAt != null) {
                                final diff = DateTime.now().difference(p.createdAt!);
                                if (diff.inDays > 0) { timeAgo = '${diff.inDays}d ago'; }
                                else if (diff.inHours > 0) { timeAgo = '${diff.inHours}h ago'; }
                                else if (diff.inMinutes > 0) { timeAgo = '${diff.inMinutes}m ago'; }
                              }

                              final questionData = {
                                'id': p.id.toString(),
                                'author': p.authorName,
                                'timeAgo': timeAgo,
                                'title': p.content.length > 80 ? '${p.content.substring(0, 80)}…' : p.content,
                                'question': p.content,
                                'votes': p.votes,
                                'commentsCount': p.commentCount,
                                'status': 'OPEN',
                                'statusColor': ColorsManager.blue,
                              };
                              return GestureDetector(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => BlocProvider.value(
                                      value: context.read<ForumsCubit>(),
                                      child: QuestionDetailsScreen(
                                        discussion: DiscussionEntity(
                                          id: state.discussionId,
                                          title: state.discussionTitle,
                                          postCount: 0,
                                        ),
                                      ),
                                    ))),
                                child: ForumQuestionCard(
                                  authorName: p.authorName,
                                  authorAvatarUrl: p.authorAvatarUrl,
                                  timeAgo: timeAgo,
                                  questionTitle: questionData['title'] as String,
                                  questionBody: p.content,
                                  votes: p.votes,
                                  commentsCount: p.commentCount,
                                  status: 'OPEN',
                                  statusColor: ColorsManager.blue,
                                  isPreview: true,
                                ),
                              );
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.courseId > 0
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () => showCreatePostDialog(
                context,
                courseId: widget.courseId,
                label: 'New Discussion',
              ),
              backgroundColor: ColorsManager.blue,
              foregroundColor: ColorsManager.white,
              child: const Icon(Icons.campaign),
            )
          : null,
    );
  }
}

// ─── Discussion tile ──────────────────────────────────────────────────────────

class _DiscussionTile extends StatelessWidget {
  final DiscussionEntity discussion;
  final bool isLight;

  const _DiscussionTile({required this.discussion, required this.isLight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ForumsCubit>(),
            child: QuestionDetailsScreen(
              discussion: discussion,
            ),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))] : [],
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: ColorsManager.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.forum_outlined, color: ColorsManager.blue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(discussion.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,
                          color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary)),
                  const SizedBox(height: 4),
                  Text('${discussion.postCount} posts',
                      style: TextStyle(fontSize: 12, color: ColorsManager.grayMedium)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: ColorsManager.grayMedium),
          ],
        ),
      ),
    );
  }
}