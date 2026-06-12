import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/error/remote_exception.dart';
import '../../domain/entities/attendance_record_entity.dart';
import '../../domain/entities/attendance_session_entity.dart';
import '../../domain/entities/course_attendance_report_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../data_sources/remote/attendance_remote_data_source.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource _remoteDataSource;

  const AttendanceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AttendanceSessionEntity>> createSession({
    required int courseId,
    required String title,
    required int duration,
    required double lat,
    required double lng,
  }) async {
    try {
      final model = await _remoteDataSource.createSession(
        courseId: courseId,
        title: title,
        duration: duration,
        lat: lat,
        lng: lng,
      );
      return Right(model);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to create session: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> markAttendance({
    required String token,
    required String deviceId,
    required double lat,
    required double lng,
  }) async {
    try {
      final success = await _remoteDataSource.markAttendance(
        token: token,
        deviceId: deviceId,
        lat: lat,
        lng: lng,
      );
      return Right(success);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to mark attendance: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecordEntity>>> getAttendedStudents(int courseId) async {
    try {
      final models = await _remoteDataSource.getAttendedStudents(courseId);
      return Right(models);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to fetch attended students: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeAttendanceRecord({
    required int courseId,
    required String studentId,
  }) async {
    try {
      final success = await _remoteDataSource.removeAttendanceRecord(
        courseId: courseId,
        studentId: studentId,
      );
      return Right(success);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to remove attendance record: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CourseAttendanceReportEntity>>> getCourseAttendanceReports(int courseId) async {
    try {
      final models = await _remoteDataSource.getCourseAttendanceReports(courseId);
      return Right(models);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to fetch course attendance reports: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecordEntity>>> getMyAttendanceHistory(int courseId) async {
    try {
      final models = await _remoteDataSource.getMyAttendanceHistory(courseId);
      return Right(models);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to fetch attendance history: ${e.toString()}'));
    }
  }
}
