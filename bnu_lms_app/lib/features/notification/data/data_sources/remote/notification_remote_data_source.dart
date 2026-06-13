import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/config/api_constants.dart';
import '../../models/notification_model.dart';
import '../../models/announcement_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<AnnouncementModel> createAnnouncement(Map<String, dynamic> data);
  Future<AnnouncementModel> updateAnnouncement(int id, Map<String, dynamic> data);
  Future<void> deleteAnnouncement(int id);
  Future<List<AnnouncementModel>> getCourseAnnouncements(int courseId);
  Future<List<AnnouncementModel>> getManageCourseAnnouncements(int courseId);
  Future<void> deleteNotification(int id);
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await dio.get(ApiConstants.notifications);
    return (response.data as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> markAsRead(int id) async {
    await dio.put('${ApiConstants.notifications}/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.put('${ApiConstants.notifications}/read-all');
  }

  @override
  Future<AnnouncementModel> createAnnouncement(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConstants.announcements, data: data);
    return AnnouncementModel.fromJson(response.data);
  }

  @override
  Future<AnnouncementModel> updateAnnouncement(int id, Map<String, dynamic> data) async {
    final response = await dio.put('${ApiConstants.announcements}/$id', data: data);
    return AnnouncementModel.fromJson(response.data);
  }

  @override
  Future<void> deleteAnnouncement(int id) async {
    await dio.delete('${ApiConstants.announcements}/$id');
  }

  @override
  Future<List<AnnouncementModel>> getCourseAnnouncements(int courseId) async {
    final response = await dio.get(ApiConstants.courseAnnouncements(courseId));
    return (response.data as List)
        .map((e) => AnnouncementModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<AnnouncementModel>> getManageCourseAnnouncements(int courseId) async {
    final response = await dio.get('${ApiConstants.announcements}/manage/$courseId');
    return (response.data as List)
        .map((e) => AnnouncementModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> deleteNotification(int id) async {
    await dio.delete('${ApiConstants.notifications}/$id');
  }
}
