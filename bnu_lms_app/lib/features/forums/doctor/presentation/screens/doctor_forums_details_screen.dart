import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../shared/network/repositories/forum_repository.dart';
import '../../../data/models/forum_model.dart';
import '../widgets/doctor_forum_question_card.dart';
import 'doctor_question_details_screen.dart';

class DoctorForumsDetailsScreen extends StatefulWidget {
  final int courseId;
  final String courseName;

  const DoctorForumsDetailsScreen({
    required this.courseId,
    required this.courseName,
    super.key,
  });

  @override
  State<DoctorForumsDetailsScreen> createState() => _DoctorForumsDetailsScreenState();
}

class _DoctorForumsDetailsScreenState extends State<DoctorForumsDetailsScreen> {
  int selectedFilterIndex = 0;
  final List<String> filters = ['All Discussions'];
  final ForumRepository _forumRepository = ForumRepository();
  late Future<List<Discussion>> _discussionsFuture;

  @override
  void initState() {
    super.initState();
    _discussionsFuture = _forumRepository.getDiscussions(widget.courseId);
  }

  Future<void> _refreshDiscussions() async {
    setState(() {
      _discussionsFuture = _forumRepository.getDiscussions(widget.courseId);
    });
  }

  void _showCreateDiscussionDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Discussion'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Discussion Title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await _forumRepository.createDiscussion(widget.courseId, controller.text);
                  Navigator.pop(context);
                  _refreshDiscussions();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
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
        title: Column(
          children: [
            Text(
              widget.courseName,
              style: isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge,
            ),
            Text(
              'Doctor View',
              style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(color: ColorsManager.blue),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.search, color: isLight ? ColorsManager.black : ColorsManager.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_none, color: isLight ? ColorsManager.black : ColorsManager.white), onPressed: () {}),
        ],
        elevation: 0,
      ),
      body: FutureBuilder<List<Discussion>>(
        future: _discussionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final discussions = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Stats Row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard('DISCUSSIONS', '${discussions.length}', 'Total', ColorsManager.blue, isLight)),
                    SizedBox(width: 12),
                    Expanded(child: _buildStatCard('NEW ACTIVITY', '0', 'Today', ColorsManager.yellow, isLight)),
                  ],
                ),
              ),

              // Filters
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedFilterIndex;
                    return GestureDetector(
                      onTap: () => setState(() => selectedFilterIndex = index),
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? ColorsManager.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? ColorsManager.blue : ColorsManager.grayMedium.withValues(alpha: 0.3)),
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
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'RECENT DISCUSSIONS',
                  style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),

              // Discussions List
              Expanded(
                child: discussions.isEmpty 
                  ? const Center(child: Text('No discussions yet.'))
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 80),
                      itemCount: discussions.length,
                      itemBuilder: (context, index) {
                        final discussion = discussions[index];
                        return GestureDetector(
                          onTap: () {
                            // TODO: Implement navigation to discussion posts
                          },
                          child: DoctorForumQuestionCard(
                            authorName: 'Course Discussion',
                            timeAgo: 'Just now',
                            tag: '#General',
                            questionTitle: discussion.title,
                            questionBody: 'Open discussion for all students in this course.',
                            replies: 0,
                            views: 0,
                            status: 'ACTIVE',
                            statusColor: ColorsManager.blue,
                            hasParticipated: true,
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDiscussionDialog,
        backgroundColor: ColorsManager.blue,
        foregroundColor: ColorsManager.white,
        child: Icon(Icons.campaign), // Megaphone icon from design
      ),
    );
  }

  Widget _buildStatCard(String title, String count, String subtitle, Color accentColor, bool isLight, {bool isAlert = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(count, style: (isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge).copyWith(fontSize: 28)),
              if (isAlert)
                Container(
                  padding: EdgeInsets.all(4),
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
