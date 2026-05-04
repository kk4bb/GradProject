class StudentDashboard {
  final String firstName;
  final String lastName;
  final String email;
  final List<EnrolledCourse> enrolledCourses;
  final List<QuizAttempt> quizAttempts;
  final List<Submission> submissions;
  final List<UpcomingItem> upcomingItems;

  StudentDashboard({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.enrolledCourses,
    required this.quizAttempts,
    required this.submissions,
    required this.upcomingItems,
  });

  String get fullName => '$firstName $lastName';

  factory StudentDashboard.fromJson(Map<String, dynamic> json) {
    return StudentDashboard(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      enrolledCourses: (json['enrolledCourses'] as List?)
              ?.map((e) => EnrolledCourse.fromJson(e))
              .toList() ??
          [],
      quizAttempts: (json['quizAttempts'] as List?)
              ?.map((e) => QuizAttempt.fromJson(e))
              .toList() ??
          [],
      submissions: (json['submissions'] as List?)
              ?.map((e) => Submission.fromJson(e))
              .toList() ??
          [],
      upcomingItems: (json['upcomingItems'] as List?)
              ?.map((e) => UpcomingItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UpcomingItem {
  final int id;
  final String title;
  final String type;
  final String courseTitle;
  final DateTime dueDate;

  UpcomingItem({
    required this.id,
    required this.title,
    required this.type,
    required this.courseTitle,
    required this.dueDate,
  });

  factory UpcomingItem.fromJson(Map<String, dynamic> json) {
    return UpcomingItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
    );
  }
}

class EnrolledCourse {
  final int id;
  final String title;
  final String instructorName;

  EnrolledCourse({
    required this.id,
    required this.title,
    required this.instructorName,
  });

  factory EnrolledCourse.fromJson(Map<String, dynamic> json) {
    return EnrolledCourse(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      instructorName: json['instructorName'] ?? '',
    );
  }
}

class QuizAttempt {
  final int id;
  final String quizTitle;
  final double score;

  QuizAttempt({
    required this.id,
    required this.quizTitle,
    required this.score,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] ?? 0,
      quizTitle: json['quizTitle'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Submission {
  final int id;
  final String assignmentTitle;
  final double grade;

  Submission({
    required this.id,
    required this.assignmentTitle,
    required this.grade,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] ?? 0,
      assignmentTitle: json['assignmentTitle'] ?? '',
      grade: (json['grade'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
