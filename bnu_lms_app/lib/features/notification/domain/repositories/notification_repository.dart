import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/announcement_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(int id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, AnnouncementModel>> createAnnouncement(Map<String, dynamic> data);
  Future<Either<Failure, AnnouncementModel>> updateAnnouncement(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteAnnouncement(int id);
  Future<Either<Failure, List<AnnouncementModel>>> getCourseAnnouncements(int courseId);
  Future<Either<Failure, List<AnnouncementModel>>> getManageCourseAnnouncements(int courseId);
  Future<Either<Failure, void>> deleteNotification(int id);
}
