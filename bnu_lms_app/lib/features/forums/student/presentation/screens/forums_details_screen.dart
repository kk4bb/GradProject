import 'package:bnu_lms_app/features/forums/data/models/forum_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/forum_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
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
  List<Discussion> _discussions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDiscussions();
  }

  Future<void> _fetchDiscussions() async {
    try {
      final discussions = await _forumRepository.getDiscussions(widget.courseId);
      if (mounted) {
        setState(() {
          _discussions = discussions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
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
          widget.forumTitle,
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.3)),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search questions...',
                            prefixIcon: Icon(Icons.search, color: ColorsManager.grayMedium),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: _discussions.length,
                        itemBuilder: (context, index) {
                          final discussion = _discussions[index];
                          // Note: ForumQuestionCard needs a mapping or conversion if it expects Map/Question object
                          // I'm passing dummy data for card fields as Discussion model is limited
                          return GestureDetector(
                            onTap: () {
                              // Navigation to Question Details remains,
                              // though might need updated to use Discussion id
                            },
                            child: ForumQuestionCard(
                              authorName: 'Unknown Author', // TODO: Map from API if available
                              timeAgo: 'Just now', // TODO: Map from API if available
                              questionTitle: discussion.title,
                              questionBody: 'No content available', // TODO: Map from API if available
                              votes: 0, // TODO: Map from API
                              commentsCount: discussion.postCount,
                              status: 'OPEN',
                              statusColor: ColorsManager.blue,
                              isPreview: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: ColorsManager.blue,
        foregroundColor: ColorsManager.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}