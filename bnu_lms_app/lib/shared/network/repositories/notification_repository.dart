import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final bool isAnnouncement;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    required this.isAnnouncement,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
      isAnnouncement: json['isAnnouncement'] ?? false,
    );
  }
}

class NotificationRepository {
  final Dio _dio = apiService.dio;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.notifications);
      return (response.data as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.post('${ApiEndpoints.markNotificationRead}$id/read');
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.post(ApiEndpoints.markAllNotificationsRead);
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }
}
