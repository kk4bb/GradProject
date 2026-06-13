import '../../domain/entities/profile_entity.dart';
import '../models/profile_model.dart';

extension ProfileMapper on ProfileModel {
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      faculty: faculty ?? 'N/A',
      academicYear: academicYear ?? 0,
      creditHours: creditHours ?? 0,
      enrolledCoursesCount: enrolledCoursesCount ?? 0,
      gpa: gpa,
      rank: rank,
      studentId: studentId,
      role: role,
      profilePictureUrl: profilePictureUrl,
    );
  }
}
