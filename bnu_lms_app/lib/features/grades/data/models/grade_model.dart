import '../../domain/entities/grade_entity.dart';

class GradeModel extends GradeEntity {
  GradeModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    super.studentAvatarUrl,
    required super.courseId,
    required super.quizzesTotal,
    required super.assignmentsTotal,
    required super.attendanceTotal,
    required super.projectGrade,
    required super.midterm1,
    required super.midterm2,
    required super.finalExam,
    required super.isTermWorkPublished,
    required super.totalGrade,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] ?? 0,
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? 'Unknown Student',
      studentAvatarUrl: json['studentAvatarUrl'],
      courseId: json['courseId'] ?? 0,
      quizzesTotal: (json['quizzesTotal'] as num?)?.toDouble() ?? 0.0,
      assignmentsTotal: (json['assignmentsTotal'] as num?)?.toDouble() ?? 0.0,
      attendanceTotal: (json['attendanceTotal'] as num?)?.toDouble() ?? 0.0,
      projectGrade: (json['projectGrade'] as num?)?.toDouble() ?? 0.0,
      midterm1: (json['midterm1'] as num?)?.toDouble() ?? 0.0,
      midterm2: (json['midterm2'] as num?)?.toDouble() ?? 0.0,
      finalExam: (json['finalExam'] as num?)?.toDouble() ?? 0.0,
      isTermWorkPublished: json['isTermWorkPublished'] ?? false,
      totalGrade: (json['totalGrade'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'studentAvatarUrl': studentAvatarUrl,
      'courseId': courseId,
      'quizzesTotal': quizzesTotal,
      'assignmentsTotal': assignmentsTotal,
      'attendanceTotal': attendanceTotal,
      'projectGrade': projectGrade,
      'midterm1': midterm1,
      'midterm2': midterm2,
      'finalExam': finalExam,
      'isTermWorkPublished': isTermWorkPublished,
      'totalGrade': totalGrade,
    };
  }
}
