import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

import '../widgets/ta_forum_card.dart';
import 'ta_question_details_screen.dart';

class TaForumsDetailsScreen extends StatelessWidget {
  const TaForumsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        appBar: AppBar(
          backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: isLight ? ColorsManager.black : ColorsManager.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TA Forum',
                style: (isLight ? AppLightTextStyles.titleLarge : AppDarkTextStyles.titleLarge)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'COMPUTER SCIENCE 101',
                style: TextStyle(fontSize: 10.sp, color: cyan, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
            ],
          ),
          actions: [
            IconButton(icon: Icon(Icons.search, color: isLight ? ColorsManager.black : ColorsManager.white), onPressed: () {}),
            IconButton(icon: Icon(Icons.filter_list, color: isLight ? ColorsManager.black : ColorsManager.white), onPressed: () {}),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: cyan,
            labelColor: cyan,
            unselectedLabelColor: ColorsManager.grayMedium,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'All Threads'),
              Tab(text: 'Suggested'),
              Tab(text: 'My Sections'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Filter Chips
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Open', true, isLight, cyan),
                    SizedBox(width: 8.w),
                    _buildFilterChip('No Accepted Answer', false, isLight, cyan),
                    SizedBox(width: 8.w),
                    _buildFilterChip('Urgent', false, isLight, cyan),
                  ],
                ),
              ),
            ),

            // Thread List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  TaForumCard(
                    status: 'OPEN',
                    statusColor: ColorsManager.green,
                    title: 'How to implement Dijkstra\'s algorithm for directed graphs?',
                    author: 'John Doe',
                    section: 'Section A • CS101',
                    repliesCount: 12,
                    actionRequired: 'No Accepted Answer',
                    isLight: isLight,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaQuestionDetailsScreen())),
                  ),
                  SizedBox(height: 16.h),
                  TaForumCard(
                    status: 'SUGGESTED ANSWER PENDING',
                    statusColor: Colors.orange,
                    title: 'Confusion regarding the midterm exam format for Lab 3',
                    author: 'Sarah Chen',
                    section: 'Section B • CS101',
                    repliesCount: 4,
                    actionRequired: 'Pending TA Review',
                    isLight: isLight,
                    onTap: () {},
                  ),
                  SizedBox(height: 16.h),
                  TaForumCard(
                    status: 'OFFICIAL ANSWER MARKED',
                    statusColor: cyan,
                    title: 'Submission deadline for Assignment 2',
                    author: 'Michael Ross',
                    section: 'Section A • CS101',
                    repliesCount: 2,
                    actionRequired: 'RESOLVED BY TA',
                    isLight: isLight,
                    onTap: () {},
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isLight, Color cyan) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? cyan : (isLight ? ColorsManager.white : ColorsManager.darkSurface),
        borderRadius: BorderRadius.circular(20.r),
        border: isSelected ? null : Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : (isLight ? ColorsManager.black : ColorsManager.white),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isSelected) ...[
            SizedBox(width: 6.w),
            Icon(Icons.close, size: 14.sp, color: Colors.white),
          ]
        ],
      ),
    );
  }
}