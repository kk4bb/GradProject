import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/remote/notification_remote_data_source.dart';
import '../models/notification_model.dart';
import '../models/announcement_model.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final result = await remoteDataSource.getNotifications();
      return Right(result);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to load notifications';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int id) async {
    try {
      await remoteDataSource.markAsRead(id);
      return const Right(null);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to mark as read';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to mark all as read';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AnnouncementModel>> createAnnouncement(Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.createAnnouncement(data);
      return Right(result);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to create announcement';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AnnouncementModel>>> getCourseAnnouncements(int courseId) async {
    try {
      final result = await remoteDataSource.getCourseAnnouncements(courseId);
      return Right(result);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to load course announcements';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, AnnouncementModel>> updateAnnouncement(int id, Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.updateAnnouncement(id, data);
      return Right(result);
    } on DioException catch (e) {
      final resData = e.response?.data;
      String message = 'Failed to update announcement';
      if (resData is Map<String, dynamic> && resData.containsKey('message')) {
        message = resData['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnnouncement(int id) async {
    try {
      await remoteDataSource.deleteAnnouncement(id);
      return const Right(null);
    } on DioException catch (e) {
      final resData = e.response?.data;
      String message = 'Failed to delete announcement';
      if (resData is Map<String, dynamic> && resData.containsKey('message')) {
        message = resData['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AnnouncementModel>>> getManageCourseAnnouncements(int courseId) async {
    try {
      final result = await remoteDataSource.getManageCourseAnnouncements(courseId);
      return Right(result);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to load manage course announcements';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(int id) async {
    try {
      await remoteDataSource.deleteNotification(id);
      return const Right(null);
    } on DioException catch (e) {
      final resData = e.response?.data;
      String message = 'Failed to delete notification';
      if (resData is Map<String, dynamic> && resData.containsKey('message')) {
        message = resData['message'];
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
