import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../widgets/fourms_details/forum_question_card.dart';
import 'question_details_screen.dart'; // Import the new screen

class ForumsDetailsScreen extends StatefulWidget {
  final String forumTitle;

  const ForumsDetailsScreen({
    required this.forumTitle,
    super.key,
  });

  @override
  State<ForumsDetailsScreen> createState() => _ForumsDetailsScreenState();
}

class _ForumsDetailsScreenState extends State<ForumsDetailsScreen> {
  int selectedFilterIndex = 0;
  final List<String> filters = ['All Questions', 'Open', 'Answered', 'Resolved'];

  // Dummy list of questions for the feed
  final List<Map<String, dynamic>> questionsList = [
    {
      'id': '1',
      'author': 'Alex Johnson',
      'timeAgo': '2h ago',
      'title': 'Differentiating viral vs bacterial pneumonia in neonates?',
      'question': 'Looking for specific clinical markers that are most reliable in early stages before lab results come back. The textbook mentions a range, but what is the standard protocol at our university clinic?',
      'votes': 15,
      'commentsCount': 0,
      'status': 'OPEN',
      'statusColor': ColorsManager.blue,
    },
    {
      'id': '2',
      'author': 'Maria Chen',
      'timeAgo': '5h ago',
      'title': 'Amoxicillin dosage for pediatric patients under 10kg',
      'question': 'The textbook mentions a range, but what is the standard protocol at our university clinic for outpatient care?',
      'votes': 8,
      'commentsCount': 4,
      'status': 'ANSWERED',
      'statusColor': ColorsManager.blueGray,
    },
    {
      'id': '3',
      'author': 'Omar Khaled',
      'timeAgo': '1d ago',
      'title': 'Reading list for next week\'s seminar?',
      'question': 'I can\'t find the PDF for the "Endocrine Disorders" module in the shared folder. Has it been uploaded yet?',
      'votes': 24,
      'commentsCount': 12,
      'status': 'RESOLVED',
      'statusColor': ColorsManager.green,
    },
  ];

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
                  hintText: 'Search questions...',
                  hintStyle: TextStyle(color: ColorsManager.grayMedium),
                  prefixIcon: Icon(Icons.search, color: ColorsManager.grayMedium),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // // Filters
          // SizedBox(
          //   height: 40,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     itemCount: filters.length,
          //     itemBuilder: (context, index) {
          //       final isSelected = index == selectedFilterIndex;
          //       return GestureDetector(
          //         onTap: () => setState(() => selectedFilterIndex = index),
          //         child: Container(
          //           margin: EdgeInsets.only(right: 8),
          //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //           decoration: BoxDecoration(
          //             color: isSelected ? ColorsManager.blue : Colors.transparent,
          //             borderRadius: BorderRadius.circular(20),
          //             border: Border.all(
          //               color: isSelected ? ColorsManager.blue : ColorsManager.grayMedium.withValues(alpha: 0.3),
          //             ),
          //           ),
          //           child: Center(
          //             child: Text(
          //               filters[index],
          //               style: TextStyle(
          //                 color: isSelected ? ColorsManager.white : (isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary),
          //                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // SizedBox(height: 8),

          // Questions List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
              itemCount: questionsList.length,
              itemBuilder: (context, index) {
                final question = questionsList[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to Question Details on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionDetailsScreen(questionData: question),
                      ),
                    );
                  },
                  child: ForumQuestionCard(
                    authorName: question['author'],
                    timeAgo: question['timeAgo'],
                    questionTitle: question['title'],
                    questionBody: question['question'],
                    votes: question['votes'],
                    commentsCount: question['commentsCount'],
                    status: question['status'],
                    statusColor: question['statusColor'],
                    isPreview: true, // Truncates text for the list view
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new question
        },
        backgroundColor: ColorsManager.blue,
        foregroundColor: ColorsManager.white,
        child: Icon(Icons.add),
      ),
    );
  }
}