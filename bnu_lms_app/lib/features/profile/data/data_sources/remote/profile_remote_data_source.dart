import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import 'package:bnu_lms_app/shared/error/remote_exception.dart';
import 'dart:io';
import 'package:bnu_lms_app/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getMyProfile();
  Future<String> uploadProfilePicture(File file);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProfileModel> getMyProfile() async {
    try {
      final response = await dio.get(ApiConstants.studentProfileMe);
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw RemoteException(
          message: e.response?.data['message'] ?? e.message ?? 'Failed to get profile');
    } catch (e) {
      throw RemoteException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(
        '${ApiConstants.baseUrl}student/profile/picture',
        data: formData,
      );

      return response.data['url'] as String;
    } on DioException catch (e) {
      throw RemoteException(
          message: e.response?.data?.toString() ?? e.message ?? 'Failed to upload image');
    } catch (e) {
      throw RemoteException(message: 'Unexpected error occurred: $e');
    }
  }
}
