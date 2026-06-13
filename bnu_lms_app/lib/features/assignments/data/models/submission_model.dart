import '../../domain/entities/submission_entity.dart';

class SubmissionModel {
  final int id;
  final int assignmentId;
  final String studentId;
  final String studentName;
  final String? fileUrl;
  final String? submissionText;
  final DateTime submissionDate;
  final double? grade;
  final String? feedback;

  SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    this.fileUrl,
    this.submissionText,
    required this.submissionDate,
    this.grade,
    this.feedback,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as int? ?? 0,
      assignmentId: json['assignmentId'] as int? ?? 0,
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      fileUrl: json['fileUrl'] as String?,
      submissionText: json['submissionText'] as String?,
      submissionDate: json['submissionDate'] != null ? DateTime.parse(json['submissionDate']) : DateTime.now(),
      grade: (json['grade'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'studentName': studentName,
      'fileUrl': fileUrl,
      'submissionText': submissionText,
      'submissionDate': submissionDate.toIso8601String(),
      'grade': grade,
      'feedback': feedback,
    };
  }

  SubmissionEntity toEntity() {
    return SubmissionEntity(
      id: id,
      assignmentId: assignmentId,
      studentId: studentId,
      studentName: studentName,
      fileUrl: fileUrl,
      submissionText: submissionText,
      submissionDate: submissionDate,
      grade: grade,
      feedback: feedback,
    );
  }
}
