import 'package:dio/dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/config/api_constants.dart';
import '../../models/grade_model.dart';

abstract class GradesRemoteDataSource {
  Future<GradeModel> getStudentGrades(int courseId, String studentId);
  Future<List<GradeModel>> getCourseGrades(int courseId);
  Future<GradeModel> updateGrades(int courseId, String studentId, Map<String, dynamic> updateData);
  Future<void> publishTermWork(int courseId);
  Future<void> unlockTermWork(int courseId);
}

@Injectable(as: GradesRemoteDataSource)
class GradesRemoteDataSourceImpl implements GradesRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  GradesRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  @override
  Future<GradeModel> getStudentGrades(int courseId, String studentId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    final response = await dio.get(
      '${ApiConstants.baseUrl}grade/$courseId/student/$studentId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return GradeModel.fromJson(response.data);
  }

  @override
  Future<List<GradeModel>> getCourseGrades(int courseId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    final response = await dio.get(
      '${ApiConstants.baseUrl}grade/$courseId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data as List).map((json) => GradeModel.fromJson(json)).toList();
  }

  @override
  Future<GradeModel> updateGrades(int courseId, String studentId, Map<String, dynamic> updateData) async {
    final token = await secureStorage.read(key: 'jwt_token');
    final response = await dio.put(
      '${ApiConstants.baseUrl}grade/$courseId/student/$studentId',
      data: updateData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return GradeModel.fromJson(response.data);
  }

  @override
  Future<void> publishTermWork(int courseId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    await dio.post(
      '${ApiConstants.baseUrl}grade/$courseId/publish',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> unlockTermWork(int courseId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    await dio.post(
      '${ApiConstants.baseUrl}grade/$courseId/unlock',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
