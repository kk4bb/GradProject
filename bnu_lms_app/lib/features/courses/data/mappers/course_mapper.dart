// lib/features/courses/data/mappers/course_mapper.dart

import '../../domain/entities/course_entity.dart';
import '../models/course_model.dart';

extension CourseSummaryMapper on CourseSummaryModel {
  CourseSummaryEntity get toEntity => CourseSummaryEntity(
        id: id,
        title: title,
        description: description,
        instructorName: instructorName,
      );
}

extension CourseDetailMapper on CourseDetailModel {
  CourseDetailEntity get toEntity => CourseDetailEntity(
        id: id,
        title: title,
        description: description,
        instructorName: instructorName,
        students: students.map((s) => s.toEntity).toList(),
        modules: modules.map((m) => m.toEntity).toList(),
      );
}

extension CourseStudentMapper on CourseStudentModel {
  CourseStudentEntity get toEntity => CourseStudentEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        profilePictureUrl: profilePictureUrl,
      );
}

extension ModuleMapper on ModuleModel {
  ModuleEntity get toEntity => ModuleEntity(
        id: id,
        title: title,
        lessons: lessons.map((l) => l.toEntity).toList(),
      );
}

extension LessonMapper on LessonModel {
  LessonEntity get toEntity => LessonEntity(
        id: id,
        title: title,
        contents: contents.map((c) => c.toEntity).toList(),
      );
}

extension EducationalContentMapper on EducationalContentModel {
  EducationalContentEntity get toEntity => EducationalContentEntity(
        id: id,
        contentType: contentType,
        fileUrl: fileUrl,
        originalFileName: originalFileName,
      );
}
