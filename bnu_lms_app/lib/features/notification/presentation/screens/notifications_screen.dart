import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/routes_manager/routes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/notification_card.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../../data/models/notification_model.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/domain/entities/auth_entity.dart';

/// Maps each filter chip label to the exact [NotificationType] index it represents.
/// Index matches the enum declaration order in notification_card.dart:
///   announcement=0, quiz=1, assignment=2, grade=3, forum=4, system=5
const Map<String, int> _filterToTypeIndex = {
  'Announcements': 0,
  'Quizzes':       1,
  'Assignments':   2,
  'Grades':        3,
  'Forums':        4,
  'System':        5,
};

/// SharedPreferences keys for each notification type preference.
const Map<String, String> _prefKeys = {
  'Announcements': 'pref_announcements',
  'Quizzes':       'pref_quizzes',
  'Assignments':   'pref_assignments',
  'Grades':        'pref_grades',
  'Forums':        'pref_forums',
  'System':        'pref_system',
};

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _filters;

  /// Tracks which notification types are enabled per user preferences.
  /// Defaults to all enabled until prefs are loaded.
  Map<String, bool> _enabledTypes = {
    'Announcements': true,
    'Quizzes':       true,
    'Assignments':   true,
    'Grades':        true,
    'Forums':        true,
    'System':        true,
  };

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    bool isStaff = false;
    if (authState is AuthSuccess) {
      isStaff = authState.auth.role.isInstructor || authState.auth.role.isTa;
    }

    if (isStaff) {
      _filters = ['All', 'Announcements', 'System'];
    } else {
      _filters = ['All', 'Announcements', 'Assignments', 'Quizzes', 'Grades', 'Forums', 'System'];
    }

    _tabController = TabController(length: _filters.length, vsync: this);
    final cubit = context.read<NotificationCubit>();
    cubit.getNotifications();
    cubit.markAllAsRead();
    _loadPreferences();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final updated = <String, bool>{};
    for (final entry in _prefKeys.entries) {
      // Default to true if key not set yet
      updated[entry.key] = prefs.getBool(entry.value) ?? true;
    }
    if (mounted) {
      setState(() => _enabledTypes = updated);
    }
  }

  // /// Returns the set of type indices the user has disabled.
  // Set<int> get _disabledTypeIndices {
  //   return _enabledTypes.entries
  //       .where((e) => !e.value)
  //       .map((e) => _filterToTypeIndex[e.key]!)
  //       .toSet();
  // }

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
          'Notifications',
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isLight ? ColorsManager.black : ColorsManager.white,
            ),
            onPressed: () async {
              // Wait for user to return from preferences, then reload
              await Navigator.pushNamed(context, Routes.notificationPreferences);
              _loadPreferences();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with mark all read
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Stay updated on your coursework',
                    style: isLight
                        ? AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.grayMedium)
                        : AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.darkTextSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => context.read<NotificationCubit>().markAllAsRead(),
                  child: Text(
                    'Mark all as read',
                    style: isLight
                        ? AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold)
                        : AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // TabBar with Quiz Screen Style
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.1) : const Color(0xFF131F24),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: const Color(0xFF26C6DA),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: ColorsManager.white,
                  unselectedLabelColor: ColorsManager.grayMedium,
                  dividerColor: Colors.transparent,
                  labelStyle: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(fontWeight: FontWeight.bold),
                  tabs: _filters.map((f) => Tab(text: f)).toList(),
                ),
              ),
            ),
          ),

          // List of Notifications in TabBarView
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                } else if (state is NotificationEmpty) {
                  return const Center(child: Text("No notifications found"));
                } else if (state is NotificationLoaded) {
                  final notifications = state.notifications as List<NotificationModel>;

                  return TabBarView(
                    controller: _tabController,
                    children: _filters.map((filter) {
                      // Apply tab filter
                      final filtered = filter == 'All'
                          ? notifications
                          : notifications.where((n) {
                              final expectedIndex = _filterToTypeIndex[filter];
                              return expectedIndex != null && n.type == expectedIndex;
                            }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            filter == 'All'
                                ? 'No notifications yet'
                                : 'No $filter notifications',
                            style: TextStyle(
                              color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final n = filtered[index];
                          return Dismissible(
                            key: Key('notification_${n.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              context.read<NotificationCubit>().deleteNotification(n.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Notification dismissed')),
                              );
                            },
                            child: NotificationCard(
                              type: NotificationType.values[n.type],
                              title: n.title,
                              body: n.message,
                              time: DateFormat('MMM d, h:mm a').format(n.createdAt),
                              isUnread: !n.isRead,
                              onTap: () {
                                if (!n.isRead) {
                                  context.read<NotificationCubit>().markAsRead(n.id);
                                }
                                Navigator.pushNamed(
                                  context,
                                  Routes.notificationDetails,
                                  arguments: {'notification': n},
                                );
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
