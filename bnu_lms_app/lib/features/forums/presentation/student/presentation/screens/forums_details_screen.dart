import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../../shared/network/repositories/forum_repository.dart';
import '../../../../data/models/forum_model.dart';
import '../widgets/fourms_details/forum_question_card.dart';

class ForumsDetailsScreen extends StatefulWidget {
  final String forumTitle;
  final int courseId;

  const ForumsDetailsScreen({
    required this.forumTitle,
    required this.courseId,
    super.key,
  });

  @override
  State<ForumsDetailsScreen> createState() => _ForumsDetailsScreenState();
}

class _ForumsDetailsScreenState extends State<ForumsDetailsScreen> {
  final ForumRepository _forumRepository = ForumRepository();
  late Future<List<Discussion>> _discussionsFuture;
  int selectedFilterIndex = 0;
  final List<String> filters = ['All Questions', 'Open', 'Answered', 'Resolved'];

  @override
  void initState() {
    super.initState();
    _discussionsFuture = _forumRepository.getDiscussions(widget.courseId);
  }

  void _refresh() {
    setState(() {
      _discussionsFuture = _forumRepository.getDiscussions(widget.courseId);
    });
  }

  Future<void> _createNewDiscussion() async {
    final titleController = TextEditingController();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Discussion'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Topic Title',
            hintText: 'e.g., Question about Assignment 1',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (confirmed == true && titleController.text.isNotEmpty) {
      try {
        await _forumRepository.createDiscussion(widget.courseId, titleController.text);
        _refresh();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
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
          widget.forumTitle,
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
              ),
              child: TextField(
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

          // Discussions List
          Expanded(
            child: FutureBuilder<List<Discussion>>(
              future: _discussionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final discussions = snapshot.data ?? [];

                if (discussions.isEmpty) {
                  return const Center(child: Text('No discussions yet. Be the first to start one!'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = discussions[index];
                    return GestureDetector(
                      onTap: () {
                        // In a real app, this would navigate to DiscussionPostsScreen
                        // For now, we'll keep the existing QuestionDetailsScreen if it works with Discussion
                      },
                      child: ForumQuestionCard(
                        authorName: 'Student', // Backend Discussion doesn't have author yet
                        timeAgo: 'Recently',
                        questionTitle: discussion.title,
                        questionBody: 'Discussion topic with ${discussion.postCount} posts.',
                        votes: 0,
                        commentsCount: discussion.postCount,
                        status: 'OPEN',
                        statusColor: ColorsManager.blue,
                        isPreview: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewDiscussion,
        backgroundColor: ColorsManager.blue,
        foregroundColor: ColorsManager.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}