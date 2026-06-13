// lib/features/courses/data/models/course_model.dart

class CourseSummaryModel {
  final int id;
  final String title;
  final String description;
  final String instructorName;

  const CourseSummaryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
  });

  factory CourseSummaryModel.fromJson(Map<String, dynamic> json) =>
      CourseSummaryModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        instructorName: json['instructorName'] as String? ?? 'Unknown',
      );
}

class CourseDetailModel {
  final int id;
  final String title;
  final String description;
  final String instructorName;
  final List<CourseStudentModel> students;
  final List<ModuleModel> modules;

  const CourseDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.students,
    required this.modules,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        instructorName: json['instructorName'] as String? ?? 'Unknown',
        students: (json['students'] as List<dynamic>?)
                ?.map((e) => CourseStudentModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        modules: (json['modules'] as List<dynamic>?)
                ?.map((e) => ModuleModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class CourseStudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePictureUrl;

  const CourseStudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePictureUrl,
  });

  factory CourseStudentModel.fromJson(Map<String, dynamic> json) =>
      CourseStudentModel(
        id: json['id'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        profilePictureUrl: json['profilePictureUrl'] as String?,
      );
}

class ModuleModel {
  final int id;
  final String title;
  final List<LessonModel> lessons;

  const ModuleModel({
    required this.id,
    required this.title,
    required this.lessons,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) => ModuleModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        lessons: (json['lessons'] as List<dynamic>?)
                ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class LessonModel {
  final int id;
  final String title;
  final List<EducationalContentModel> contents;

  const LessonModel({
    required this.id,
    required this.title,
    required this.contents,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        contents: (json['contents'] as List<dynamic>?)
                ?.map((e) =>
                    EducationalContentModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class EducationalContentModel {
  final int id;
  final String contentType;
  final String fileUrl;

  const EducationalContentModel({
    required this.id,
    required this.contentType,
    required this.fileUrl,
  });

  factory EducationalContentModel.fromJson(Map<String, dynamic> json) =>
      EducationalContentModel(
        id: json['id'] as int,
        contentType: json['contentType'] as String? ?? '',
        fileUrl: json['fileUrl'] as String? ?? '',
      );
}
