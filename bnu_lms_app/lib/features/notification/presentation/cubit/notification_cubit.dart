import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../../shared/services/signalr_service.dart';
import 'dart:async';
import 'notification_state.dart';

@lazySingleton
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  final SignalRService signalRService;
  StreamSubscription? _notificationSub;
  StreamSubscription? _announcementUpdateSub;
  StreamSubscription? _announcementDeleteSub;
  int? _lastCourseId;
  bool _isManaging = false;

  NotificationCubit({required this.repository, required this.signalRService}) : super(NotificationInitial()) {
    _notificationSub = signalRService.newNotificationStream.listen((event) {
      if (isClosed) return;
      if (_lastCourseId != null) {
        if (_isManaging) {
          getManageCourseAnnouncements(_lastCourseId!, silent: true);
        } else {
          getCourseAnnouncements(_lastCourseId!, silent: true);
        }
      } else {
        getNotifications(silent: true);
      }
    });

    _announcementUpdateSub = signalRService.announcementUpdatedStream.listen((event) {
      if (isClosed) return;
      if (_lastCourseId != null) {
        if (_isManaging) {
          getManageCourseAnnouncements(_lastCourseId!, silent: true);
        } else {
          getCourseAnnouncements(_lastCourseId!, silent: true);
        }
      }
    });

    _announcementDeleteSub = signalRService.announcementDeletedStream.listen((event) {
      if (isClosed) return;
      if (_lastCourseId != null) {
        if (_isManaging) {
          getManageCourseAnnouncements(_lastCourseId!, silent: true);
        } else {
          getCourseAnnouncements(_lastCourseId!, silent: true);
        }
      }
    });
  }

  @override
  Future<void> close() {
    _notificationSub?.cancel();
    _announcementUpdateSub?.cancel();
    _announcementDeleteSub?.cancel();
    return super.close();
  }

  Future<void> getNotifications({bool silent = false}) async {
    if (!silent) emit(NotificationLoading());
    final result = await repository.getNotifications();
    result.fold(
      (failure) { if (!silent) emit(NotificationError(failure.toString())); },
      (notifications) {
        if (notifications.isEmpty) {
          emit(NotificationEmpty());
        } else {
          emit(NotificationLoaded(notifications));
        }
      },
    );
  }

  Future<void> getCourseAnnouncements(int courseId, {bool silent = false}) async {
    _lastCourseId = courseId;
    _isManaging = false;
    if (!silent) emit(AnnouncementLoading());
    final result = await repository.getCourseAnnouncements(courseId);
    result.fold(
      (failure) { if (!silent) emit(NotificationError(failure.toString())); },
      (announcements) {
        if (announcements.isEmpty) {
          emit(NotificationEmpty());
        } else {
          emit(AnnouncementLoaded(announcements));
        }
      },
    );
  }

  Future<void> getManageCourseAnnouncements(int courseId, {bool silent = false}) async {
    _lastCourseId = courseId;
    _isManaging = true;
    if (!silent) emit(AnnouncementLoading());
    final result = await repository.getManageCourseAnnouncements(courseId);
    result.fold(
      (failure) { if (!silent) emit(NotificationError(failure.toString())); },
      (announcements) {
        if (announcements.isEmpty) {
          emit(NotificationEmpty());
        } else {
          emit(AnnouncementLoaded(announcements));
        }
      },
    );
  }

  Future<void> markAsRead(int id) async {
    await repository.markAsRead(id);
    getNotifications(silent: true);
  }

  Future<void> markAllAsRead() async {
    await repository.markAllAsRead();
    getNotifications(silent: true);
  }

  /// Returns the unread count, excluding notification types the user has disabled
  /// in SharedPreferences. Used by the bell badge widget.
  Future<int> getEnabledUnreadCount() async {
    if (state is! NotificationLoaded) return 0;
    final notifications = (state as NotificationLoaded).notifications;

    const Map<String, int> prefKeyToTypeIndex = {
      'pref_announcements': 0,
      'pref_quizzes':       1,
      'pref_assignments':   2,
      'pref_grades':        3,
      'pref_forums':        4,
      'pref_system':        5,
    };

    final prefs = await SharedPreferences.getInstance();
    final disabledIndices = prefKeyToTypeIndex.entries
        .where((e) => !(prefs.getBool(e.key) ?? true))
        .map((e) => e.value)
        .toSet();

    return notifications
        .where((n) => !n.isRead && !disabledIndices.contains(n.type))
        .length;
  }

  Future<void> postAnnouncement(Map<String, dynamic> data) async {
    emit(NotificationLoading());
    final result = await repository.createAnnouncement(data);
    result.fold(
      (failure) => emit(NotificationError(failure.toString())),
      (_) => emit(AnnouncementPostedSuccess()),
    );
  }

  Future<void> updateAnnouncement(int id, Map<String, dynamic> data) async {
    emit(NotificationLoading());
    final result = await repository.updateAnnouncement(id, data);
    result.fold(
      (failure) => emit(NotificationError(failure.toString())),
      (_) {
        emit(AnnouncementPostedSuccess());
        if (_lastCourseId != null) {
          if (_isManaging) {
            getManageCourseAnnouncements(_lastCourseId!, silent: true);
          } else {
            getCourseAnnouncements(_lastCourseId!, silent: true);
          }
        }
      },
    );
  }

  Future<void> deleteAnnouncement(int id) async {
    final result = await repository.deleteAnnouncement(id);
    result.fold(
      (failure) => emit(NotificationError(failure.toString())),
      (_) {
        if (_lastCourseId != null) {
          if (_isManaging) {
            getManageCourseAnnouncements(_lastCourseId!, silent: true);
          } else {
            getCourseAnnouncements(_lastCourseId!, silent: true);
          }
        }
      },
    );
  }

  Future<void> deleteNotification(int id) async {
    final result = await repository.deleteNotification(id);
    result.fold(
      (failure) => emit(NotificationError(failure.toString())),
      (_) => getNotifications(silent: true),
    );
  }
}
