import 'package:equatable/equatable.dart';

class AssignmentEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final double maxPoints;
  final String status; // Upcoming, Submitted, Graded, Late
  final int? courseId;
  final String? instructorName;
  final double? grade;
  final String? feedback;
  final String? filePath;
  final int attempts;

  const AssignmentEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.maxPoints,
    required this.status,
    this.courseId,
    this.instructorName,
    this.grade,
    this.feedback,
    this.filePath,
    this.attempts = 0,
  });

  @override
  List<Object?> get props => [id, title, description, dueDate, maxPoints, status, grade, filePath, attempts];
}
