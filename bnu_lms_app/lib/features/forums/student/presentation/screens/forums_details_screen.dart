import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/network/repositories/forum_repository.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../data/models/forum_model.dart';
import '../widgets/fourms_details/forum_question_card.dart';
import 'question_details_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _discussionsFuture = _forumRepository.getDiscussions(widget.courseId);
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

                final discussions = snapshot.data!;
                if (discussions.isEmpty) {
                  return const Center(child: Text('No discussions found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = discussions[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionDetailsScreen(
                              discussionId: discussion.id,
                              discussionTitle: discussion.title,
                            ),
                          ),
                        );
                      },
                      child: ForumQuestionCard(
                        authorName: 'Discussion',
                        timeAgo: '',
                        questionTitle: discussion.title,
                        questionBody: '${discussion.postCount} posts in this discussion.',
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
        onPressed: () {
          // TODO: Add new discussion (usually instructor only but endpoint exists for posts)
        },
        backgroundColor: ColorsManager.blue,
        foregroundColor: ColorsManager.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}