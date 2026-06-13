abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<dynamic> notifications;
  NotificationLoaded(this.notifications);
}

class AnnouncementLoading extends NotificationState {}

class AnnouncementLoaded extends NotificationState {
  final List<dynamic> announcements;
  AnnouncementLoaded(this.announcements);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationEmpty extends NotificationState {}

class AnnouncementPostedSuccess extends NotificationState {}
