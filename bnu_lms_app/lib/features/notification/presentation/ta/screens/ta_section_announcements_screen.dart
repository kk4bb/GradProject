import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/routes_manager/routes.dart';

import '../../widgets/announcement_card.dart';

class TaSectionAnnouncementsScreen extends StatefulWidget {
  const TaSectionAnnouncementsScreen({super.key});

  @override
  State<TaSectionAnnouncementsScreen> createState() => _TaSectionAnnouncementsScreenState();
}

class _TaSectionAnnouncementsScreenState extends State<TaSectionAnnouncementsScreen> {
  String _selectedSection = 'All Sections';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isLight ? ColorsManager.black : ColorsManager.white,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Section Announcements',
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.createAnnouncement);
        },
        backgroundColor: const Color(0xFF2FBAD7), // TA Cyan
        child: const Icon(Icons.add, color: ColorsManager.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(context, 'Active', '3', isLight),
                _buildStatCard(context, 'Read Rate', '85%', isLight),
                _buildStatCard(context, 'Scheduled', '1', isLight),
              ],
            ),
          ),

          // Filter by Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by Section',
                  style: isLight 
                      ? AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.grayMedium)
                      : AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.darkTextSecondary),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLight ? const Color(0xFFF1F5F9) : ColorsManager.darkSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSection,
                      icon: Icon(Icons.keyboard_arrow_down, size: 16, color: isLight ? ColorsManager.grayDark : ColorsManager.white),
                      style: TextStyle(
                        color: isLight ? ColorsManager.black : ColorsManager.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      dropdownColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSection = newValue;
                          });
                        }
                      },
                      items: <String>['All Sections', 'Section A', 'Section B', 'Section C']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of Announcements
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                AnnouncementCard(
                  title: 'Lab 4 Submission Clarification',
                  course: 'CS301 - Lab Session',
                  target: 'SECTION A & B',
                  time: 'Today 10:00',
                  reachCount: 45,
                  isPinned: true,
                  urgency: AnnouncementUrgency.urgent,
                  onEdit: () {},
                  onDelete: () {},
                  onView: () {},
                ),
                AnnouncementCard(
                  title: 'Optional Review Session',
                  course: 'SWE400 - Tutorial',
                  target: 'ALL SECTIONS',
                  time: 'Yesterday 14:30',
                  reachCount: 88,
                  isPinned: false,
                  urgency: AnnouncementUrgency.info,
                  onEdit: () {},
                  onDelete: () {},
                  onView: () {},
                ),
                AnnouncementCard(
                  title: 'Bring Laptops to Lab',
                  course: 'CS301 - Lab Session',
                  target: 'SECTION C ONLY',
                  time: '10/12/2023 09:00',
                  reachCount: 22,
                  isPinned: false,
                  urgency: AnnouncementUrgency.reminder,
                  onEdit: () {},
                  onDelete: () {},
                  onView: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, bool isLight) {
    return Container(
      width: 105,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isLight ? const Color(0xFFEAF8FB) : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLight ? const Color(0xFF2FBAD7).withValues(alpha: 0.2) : ColorsManager.darkBackground,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
              fontSize: 11,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isLight ? const Color(0xFF0097A7) : ColorsManager.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
