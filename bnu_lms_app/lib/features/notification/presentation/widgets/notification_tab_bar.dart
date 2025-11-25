import 'package:bnu_lms_app/features/notification/presentation/widgets/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/resources/colors_manager.dart';
import 'notification_card.dart';

class NotificationTabBar extends StatelessWidget {
  const NotificationTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TabBar(
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              labelPadding: REdgeInsets.only(right: 12),
              indicator: BoxDecoration(
                color: ColorsManager.blue,
                borderRadius: BorderRadius.circular(24.r),
              ),
              labelColor: ColorsManager.white,
              unselectedLabelColor: ColorsManager.blueGray,
              tabs: const [
                TabItem(title: 'All'),
                TabItem(title: 'Unread'),
                TabItem(title: 'Announcements'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildNotificationList(),
                _buildNotificationList(unreadOnly: true),
                _buildNotificationList(announcementsOnly: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList({
    bool unreadOnly = false,
    bool announcementsOnly = false,
  }) {
    final notifications = _getNotifications(
      unreadOnly: unreadOnly,
      announcementsOnly: announcementsOnly,
    );

    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications',

        ),
      );
    }

    return ListView.separated(
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationCard(
          title: notification['title']!,
          description: notification['description']!,
          time: notification['time']!,
          icon: notification['icon'] as IconData,
          indicatorColor: notification['indicatorColor'] as Color,
        );
      },
    );
  }

  List<Map<String, dynamic>> _getNotifications({
    bool unreadOnly = false,
    bool announcementsOnly = false,
  }) {
    final allNotifications = [
      {
        'title': 'Final Project Deadline',
        'description': "Your 'Advanced Algorithms' final project is due tomorrow.",
        'time': '15m ago',
        'icon': Icons.warning_rounded,
        'indicatorColor': Colors.red,
        'isRead': false,
        'isAnnouncement': false,
      },
      {
        'title': 'Grade Update',
        'description': "Your midterm grade for 'Physics II' has been posted.",
        'time': '2h ago',
        'icon': Icons.star_outline_rounded,
        'indicatorColor': Colors.orange,
        'isRead': false,
        'isAnnouncement': false,
      },
      {
        'title': 'New Announcement',
        'description': "Check the new announcement in 'Introduction to AI'.",
        'time': '1d ago',
        'icon': Icons.campaign_outlined,
        'indicatorColor': ColorsManager.blue,
        'isRead': false,
        'isAnnouncement': true,
      },
      {
        'title': 'Campus Event',
        'description': 'Tech symposium this Friday at the main auditorium.',
        'time': '3d ago',
        'icon': Icons.calendar_today_outlined,
        'indicatorColor': ColorsManager.blue.withValues(alpha: 0.7),
        'isRead': true,
        'isAnnouncement': true,
      },
      {
        'title': 'Assignment Reminder',
        'description': "'Data Structures' assignment 3 is due next week.",
        'time': '4d ago',
        'icon': Icons.assignment_outlined,
        'indicatorColor': Colors.orange.withValues(alpha: 0.7),
        'isRead': true,
        'isAnnouncement': false,
      },
    ];

    if (unreadOnly) {
      return allNotifications.where((n) => n['isRead'] == false).toList();
    }

    if (announcementsOnly) {
      return allNotifications.where((n) => n['isAnnouncement'] == true).toList();
    }

    return allNotifications;
  }
}

