// lib/features/courses/domain/entities/course_entity.dart

import 'package:equatable/equatable.dart';

class CourseSummaryEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String instructorName;

  const CourseSummaryEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
  });

  @override
  List<Object?> get props => [id, title, description, instructorName];
}

class CourseDetailEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String instructorName;
  final List<ModuleEntity> modules;

  const CourseDetailEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.modules,
  });

  @override
  List<Object?> get props => [id, title, description, instructorName, modules];
}

class ModuleEntity extends Equatable {
  final int id;
  final String title;
  final List<LessonEntity> lessons;

  const ModuleEntity({
    required this.id,
    required this.title,
    required this.lessons,
  });

  @override
  List<Object?> get props => [id, title, lessons];
}

class LessonEntity extends Equatable {
  final int id;
  final String title;
  final List<EducationalContentEntity> contents;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.contents,
  });

  @override
  List<Object?> get props => [id, title, contents];
}

class EducationalContentEntity extends Equatable {
  final int id;
  final String contentType;
  final String fileUrl;

  const EducationalContentEntity({
    required this.id,
    required this.contentType,
    required this.fileUrl,
  });

  @override
  List<Object?> get props => [id, contentType, fileUrl];
}
