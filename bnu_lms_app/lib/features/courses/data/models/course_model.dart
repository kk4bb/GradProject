class CourseSummary {
  final int id;
  final String title;
  final String description;
  final String instructorName;

  CourseSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
  });

  factory CourseSummary.fromJson(Map<String, dynamic> json) {
    return CourseSummary(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructorName: json['instructorName'] ?? '',
    );
  }
}

class CourseDetail {
  final int id;
  final String title;
  final String description;
  final String instructorName;
  final List<CourseModule> modules;

  CourseDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.modules,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructorName: json['instructorName'] ?? '',
      modules: (json['modules'] as List?)
              ?.map((e) => CourseModule.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CourseModule {
  final int id;
  final String title;
  final List<CourseLesson> lessons;

  CourseModule({
    required this.id,
    required this.title,
    required this.lessons,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      lessons: (json['lessons'] as List?)
              ?.map((e) => CourseLesson.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CourseLesson {
  final int id;
  final String title;
  final List<EducationalContent> contents;

  CourseLesson({
    required this.id,
    required this.title,
    required this.contents,
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      contents: (json['contents'] as List?)
              ?.map((e) => EducationalContent.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class EducationalContent {
  final int id;
  final String contentType;
  final String fileUrl;

  EducationalContent({
    required this.id,
    required this.contentType,
    required this.fileUrl,
  });

  factory EducationalContent.fromJson(Map<String, dynamic> json) {
    return EducationalContent(
      id: json['id'] ?? 0,
      contentType: json['contentType'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
    );
  }
}
