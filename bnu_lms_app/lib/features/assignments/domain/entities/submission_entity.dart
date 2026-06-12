import 'package:equatable/equatable.dart';

class SubmissionEntity extends Equatable {
  final int id;
  final int assignmentId;
  final String studentId;
  final String studentName;
  final String? fileUrl;
  final String? submissionText;
  final DateTime submissionDate;
  final double? grade;
  final String? feedback;

  const SubmissionEntity({
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

  @override
  List<Object?> get props => [id, assignmentId, studentId, grade];
}
