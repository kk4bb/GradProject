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
import '../../../doctor/presentation/screens/doctor_question_details_screen.dart';
import '../../../doctor/presentation/widgets/doctor_forum_question_card.dart';
import '../../../../../../shared/services/signalr_service.dart';


class TaForumsDetailsScreen extends StatelessWidget {
  final String courseName;
  final int courseId;

  const TaForumsDetailsScreen({
    required this.courseName,
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
      child: _TaForumsDetailsBody(courseName: courseName, courseId: courseId),
    );
  }
}

class _TaForumsDetailsBody extends StatefulWidget {
  final String courseName;
  final int courseId;

  const _TaForumsDetailsBody({required this.courseName, required this.courseId});

  @override
  State<_TaForumsDetailsBody> createState() => _TaForumsDetailsBodyState();
}

class _TaForumsDetailsBodyState extends State<_TaForumsDetailsBody> {
  int selectedFilterIndex = 0;
  final List<String> filters = ['All Questions', 'Unanswered'];
  String _searchQuery = '';

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
        title: Column(
          children: [
            Text(
              widget.courseName,
              style: isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge,
            ),
            Text(
              'TA View',
              style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall)
                  .copyWith(color: ColorsManager.blue),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search Bar (FIRST) ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                  hintText: 'Search discussions...',
                  hintStyle: TextStyle(color: ColorsManager.grayMedium),
                  prefixIcon: Icon(Icons.search, color: ColorsManager.grayMedium),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── TA Stats Row (Dynamic) ───────────────────────────────────────────
          BlocBuilder<ForumsCubit, ForumsState>(
            builder: (context, state) {
              String newCount = '--';
              String pendingCount = '--';
              if (state is DiscussionsLoaded || state.discussions.isNotEmpty) {
                newCount = state.discussions.length.toString();
                pendingCount = state.discussions.where((d) => d.postCount == 0).length.toString();
              }
              
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard('NEW DISCUSSIONS', newCount, 'Live', ColorsManager.blue, isLight)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('PENDING ACTION', pendingCount, '!', ColorsManager.yellow, isLight, isAlert: true)),
                  ],
                ),
              );
            },
          ),

          // ── Filters ─────────────────────────────────────────────────────────
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedFilterIndex;
                return GestureDetector(
                  onTap: () => setState(() => selectedFilterIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? ColorsManager.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? ColorsManager.blue : ColorsManager.grayMedium.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          color: isSelected ? ColorsManager.white : (isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'RECENT DISCUSSIONS',
              style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall)
                  .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),

          // Dynamic discussions feed
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
                        
                        var filtered = state.discussions;
                        if (selectedFilterIndex == 1) {
                          filtered = filtered.where((d) => d.postCount == 0).toList();
                        }
                        if (_searchQuery.isNotEmpty) {
                          filtered = filtered.where((d) => d.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                        }
                        
                        return RefreshIndicator(
                          onRefresh: () => context.read<ForumsCubit>().loadDiscussions(widget.courseId),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final d = filtered[index];
                              return _DiscussionTile(discussion: d, isLight: isLight, courseId: widget.courseId);
                            },
                          ),
                        );
                      }

                      if (state is PostsLoaded) {
                        return RefreshIndicator(
                          onRefresh: () => context.read<ForumsCubit>().loadPosts(state.discussionId, state.discussionTitle),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: state.posts.length,
                            itemBuilder: (context, index) {
                              final p = state.posts[index];
                                return _PostTile(post: p, isLight: isLight, onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ForumsCubit>(),
                                      child: DoctorQuestionDetailsScreen(
                                        discussion: DiscussionEntity(
                                          id: state.discussionId,
                                          title: state.discussionTitle,
                                          postCount: 0,
                                        ),
                                      ),
                                    ),
                                  ));
                                });
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

  Widget _buildStatCard(String title, String count, String subtitle, Color accentColor, bool isLight, {bool isAlert = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(count, style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(fontSize: 28)),
              if (isAlert)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: Icon(Icons.priority_high, color: accentColor, size: 14),
                )
              else
                Text(subtitle, style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared tiles ─────────────────────────────────────────────────────────────

class _DiscussionTile extends StatelessWidget {
  final DiscussionEntity discussion;
  final bool isLight;
  final int courseId;

  const _DiscussionTile({required this.discussion, required this.isLight, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ForumsCubit>(),
            child: DoctorQuestionDetailsScreen(
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

class _PostTile extends StatelessWidget {
  final PostEntity post;
  final bool isLight;
  final VoidCallback onTap;

  const _PostTile({required this.post, required this.isLight, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DoctorForumQuestionCard(
        authorName: post.authorName,
        timeAgo: '',
        tag: '',
        questionTitle: post.content.length > 80 ? '${post.content.substring(0, 80)}…' : post.content,
        questionBody: post.content,
        replies: post.commentCount,
        views: 0,
        status: 'OPEN',
        statusColor: ColorsManager.blue,
        hasParticipated: false,
      ),
    );
  }
}
