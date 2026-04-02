import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../student/presentation/widgets/fourms_details/forum_answer_input.dart';
import '../widgets/doctor_forum_answer_card.dart';

class DoctorQuestionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> questionData;

  const DoctorQuestionDetailsScreen({
    required this.questionData,
    super.key,
  });

  @override
  State<DoctorQuestionDetailsScreen> createState() => _DoctorQuestionDetailsScreenState();
}

class _DoctorQuestionDetailsScreenState extends State<DoctorQuestionDetailsScreen> {
  final TextEditingController answerController = TextEditingController();

  final List<Map<String, dynamic>> studentAnswers = [
    {
      'author': 'Mark Spencer',
      'timeAgo': '1 hour ago',
      'answer': 'I used the Python `heapq` module and it worked fine for the same project last semester. Make sure your graph is an adjacency list and not a matrix!',
      'isCorrect': false,
    },
    {
      'author': 'Elena Ruiz',
      'timeAgo': '45 mins ago',
      'answer': 'Wait, is the matrix representation always slower for Dijkstra? I thought for dense graphs it might be better?',
      'isCorrect': false,
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
          icon: Icon(Icons.arrow_back, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Question Details', style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.more_vert, color: isLight ? ColorsManager.black : ColorsManager.white), onPressed: () {}),
        ],
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

                  // Doctor's Approved Answer (If exists)
                  _buildDoctorApprovedAnswer(isLight),
                  SizedBox(height: 24),

                  Text(
                    'STUDENT RESPONSES (${studentAnswers.length})',
                    style: (isLight ? AppLightTextStyles.labelSmall : AppDarkTextStyles.labelSmall).copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  SizedBox(height: 12),

                  // Student Answers List
                  ...studentAnswers.map((answer) => DoctorForumAnswerCard(
                    authorName: answer['author'],
                    timeAgo: answer['timeAgo'],
                    answerText: answer['answer'],
                    isCorrect: answer['isCorrect'],
                    onMarkCorrect: () {
                      setState(() {
                        answer['isCorrect'] = !answer['isCorrect'];
                      });
                    },
                  )),
                ],
              ),
            ),
          ),
          ForumAnswerInput(
            controller: answerController,
            onSubmit: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFullQuestion(bool isLight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildTag('RESOLVED', ColorsManager.green),
            SizedBox(width: 8),
            _buildTag('CS402: ALGORITHMS', ColorsManager.grayMedium),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(radius: 16, backgroundColor: ColorsManager.grayMedium),
            SizedBox(width: 8),
            Text('Alex Thompson • 3 hours ago', style: TextStyle(color: ColorsManager.grayMedium, fontSize: 12)),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'How do I implement Dijkstra\'s algorithm for the final project pathfinder?',
          style: (isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text(
          'I\'m struggling with the priority queue implementation. The graph has over 5,000 nodes, and my current approach is timing out. Should I use a Fibonacci heap or is a binary heap sufficient for the university\'s performance requirements?',
          style: isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium,
        ),
        SizedBox(height: 16),
        // Pin to Top Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.push_pin, color: ColorsManager.green, size: 16),
            label: Text('PIN TO TOP', style: TextStyle(color: ColorsManager.green, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: ColorsManager.green),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDoctorApprovedAnswer(bool isLight) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.green.withValues(alpha: 0.05) : ColorsManager.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.green.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: ColorsManager.green, size: 16),
              SizedBox(width: 8),
              Text('DOCTOR APPROVED ANSWER', style: TextStyle(color: ColorsManager.green, fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: ColorsManager.blue),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. Sarah Jenkins', style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                  Text('DEPARTMENT HEAD', style: TextStyle(color: ColorsManager.grayMedium, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              Spacer(),
              Icon(Icons.verified, color: ColorsManager.green),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '"For a graph of 5,000 nodes, a binary heap is perfectly adequate. The bottleneck is likely in how you\'re updating the distances. Ensure you\'re using a \'lazy\' deletion approach or a dict to track entry references for O(log n) updates."',
            style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}