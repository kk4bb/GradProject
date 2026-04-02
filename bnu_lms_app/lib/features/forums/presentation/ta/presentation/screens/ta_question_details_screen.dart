import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

import '../widgets/ta_forum_reply_card.dart';

class TaQuestionDetailsScreen extends StatelessWidget {
  const TaQuestionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: isLight ? ColorsManager.black : ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thread Details',
          style: (isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge).copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: isLight ? ColorsManager.black : ColorsManager.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                // Original Question
                _buildOriginalQuestion(isLight, cyan),

                SizedBox(height: 24.h),

                // Replies Header
                Text(
                  'Replies (3)',
                  style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),

                // Doctor Reply
                const TaForumReplyCard(
                  authorName: 'Dr. Sarah Wilson',
                  role: 'DOCTOR',
                  timeAgo: '2h ago',
                  content: 'Yes, Alex. Using a heap-based priority queue is essential. Python\'s `heapq` module provides a min-heap implementation that will reduce your complexity from O(V²) to O(E log V).',
                  upvotes: 12,
                  canSuggestAsAnswer: false,
                ),

                // TA Suggested Reply (Your Reply)
                const TaForumReplyCard(
                  authorName: 'James Chen',
                  role: 'TA (YOU)',
                  timeAgo: '1h ago',
                  content: 'I\'ve uploaded a sample snippet to the resources folder. Remember to handle the case where a shorter path to an already visited node is found!',
                  upvotes: 4,
                  isSuggestedByTa: true,
                  canSuggestAsAnswer: false,
                ),

                // Student Reply
                const TaForumReplyCard(
                  authorName: 'Mark Johnson',
                  role: 'STUDENT',
                  timeAgo: '30m ago',
                  content: 'Check out the `heapq` documentation for the `heappush` and `heappop` methods, it\'s very straightforward to use.',
                  upvotes: 2,
                  canSuggestAsAnswer: true, // TA can suggest this student's answer!
                ),
              ],
            ),
          ),

          // Bottom Input Field
          _buildBottomInput(isLight, cyan),
        ],
      ),
    );
  }

  Widget _buildOriginalQuestion(bool isLight, Color cyan) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18.r, backgroundColor: cyan.withValues(alpha: 0.2), child: Text('AS', style: TextStyle(color: cyan, fontWeight: FontWeight.bold, fontSize: 12.sp))),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alex Smith', style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold)),
                  Text('Student • CS101 • 4h ago', style: TextStyle(fontSize: 10.sp, color: ColorsManager.grayMedium)),
                ],
              )
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'How do I implement Dijkstra\'s algorithm in Python efficiently for a large graph?',
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            'I\'m working on the pathfinding assignment and my current implementation is too slow. I\'m using a simple list for the priority queue. Should I be using heapq or something else to speed it up?',
            style: TextStyle(fontSize: 13.sp, color: isLight ? Colors.grey.shade700 : Colors.grey.shade300, height: 1.5),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildTag('ALGORITHMS', cyan),
              SizedBox(width: 8.w),
              _buildTag('PYTHON', cyan),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color cyan) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: cyan.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6.r)),
      child: Text(text, style: TextStyle(color: cyan, fontSize: 10.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomInput(bool isLight, Color cyan) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, color: cyan, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Write a reply as TA...',
                hintStyle: TextStyle(color: ColorsManager.grayMedium, fontSize: 14.sp),
                border: InputBorder.none,
                filled: true,
                fillColor: isLight ? Colors.grey.shade100 : ColorsManager.darkBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: cyan, shape: BoxShape.circle),
            child: Icon(Icons.send, color: Colors.white, size: 18.sp),
          )
        ],
      ),
    );
  }
}