import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../widgets/doctor_forum_question_card.dart';
import 'doctor_question_details_screen.dart';

class DoctorForumsDetailsScreen extends StatefulWidget {
  final String courseName;

  const DoctorForumsDetailsScreen({
    required this.courseName,
    super.key,
  });

  @override
  State<DoctorForumsDetailsScreen> createState() => _DoctorForumsDetailsScreenState();
}

class _DoctorForumsDetailsScreenState extends State<DoctorForumsDetailsScreen> {
  int selectedFilterIndex = 0;
  final List<String> filters = ['All Questions', 'Unanswered', 'My Replies'];

  final List<Map<String, dynamic>> questionsList = [
    {
      'id': '1',
      'author': 'Alex Johnson',
      'timeAgo': '24 mins ago',
      'tag': '#LabNotes',
      'title': 'How to interpret the clinical markers in Lab 4\'s patient profile?',
      'question': 'I\'m having trouble understanding why the CRP levels are elevated despite the absence of...',
      'replies': 3,
      'views': 142,
      'status': 'PENDING',
      'statusColor': ColorsManager.yellow,
      'hasParticipated': false,
    },
    {
      'id': '2',
      'author': 'Sarah Williams',
      'timeAgo': '2 hours ago',
      'tag': '#FinalProject',
      'title': 'Submission deadline for the final project?',
      'question': 'Can you confirm if the deadline is Sunday at midnight or Monday morning? The syllabus says...',
      'replies': 1,
      'views': 89,
      'status': 'RESOLVED',
      'statusColor': ColorsManager.green,
      'hasParticipated': true,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Stats Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: _buildStatCard('NEW QUESTIONS', '12', '+4 today', ColorsManager.blue, isLight)),
                SizedBox(width: 12),
                Expanded(child: _buildStatCard('PENDING ACTION', '08', '!', ColorsManager.yellow, isLight, isAlert: true)),
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

          // Questions List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: questionsList.length,
              itemBuilder: (context, index) {
                final question = questionsList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorQuestionDetailsScreen(questionData: question),
                      ),
                    );
                  },
                  child: DoctorForumQuestionCard(
                    authorName: question['author'],
                    timeAgo: question['timeAgo'],
                    tag: question['tag'],
                    questionTitle: question['title'],
                    questionBody: question['question'],
                    replies: question['replies'],
                    views: question['views'],
                    status: question['status'],
                    statusColor: question['statusColor'],
                    hasParticipated: question['hasParticipated'],
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