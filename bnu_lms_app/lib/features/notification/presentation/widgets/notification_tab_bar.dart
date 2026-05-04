import 'package:bnu_lms_app/features/notification/presentation/widgets/tab_item.dart';
import 'package:flutter/material.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/network/repositories/notification_repository.dart';
import 'notification_card.dart';

class NotificationTabBar extends StatefulWidget {
  const NotificationTabBar({super.key});

  @override
  State<NotificationTabBar> createState() => _NotificationTabBarState();
}

class _NotificationTabBarState extends State<NotificationTabBar> {
  final NotificationRepository _notificationRepository = NotificationRepository();
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationRepository.getNotifications();
  }

  void _refresh() {
    setState(() {
      _notificationsFuture = _notificationRepository.getNotifications();
    });
  }

  Future<void> _markAsRead(int id) async {
    try {
      await _notificationRepository.markAsRead(id);
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TabBar(
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.only(right: 12),
              indicator: BoxDecoration(
                color: ColorsManager.blue,
                borderRadius: BorderRadius.circular(24.0),
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
            child: FutureBuilder<List<NotificationModel>>(
              future: _notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allNotifications = snapshot.data ?? [];

                return TabBarView(
                  children: [
                    _buildNotificationList(allNotifications),
                    _buildNotificationList(allNotifications.where((n) => !n.isRead).toList()),
                    _buildNotificationList(allNotifications.where((n) => n.isAnnouncement).toList()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('No notifications'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8.0),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        
        // Helper to format time (simplified)
        final timeStr = '${notification.createdAt.hour}:${notification.createdAt.minute.toString().padLeft(2, '0')}';

        return NotificationCard(
          title: notification.title,
          description: notification.message,
          time: timeStr,
          icon: notification.isAnnouncement ? Icons.campaign_outlined : Icons.notifications_outlined,
          indicatorColor: notification.isAnnouncement ? ColorsManager.blue : Colors.orange,
          isRead: notification.isRead,
          onMarkAsRead: () => _markAsRead(notification.id),
        );
      },
    );
  }
}
