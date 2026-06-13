import '../../domain/entities/assignment_entity.dart';

class AssignmentModel {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final double maxPoints;
  final String status;
  final int? courseId;
  final String? instructorName;
  final double? grade;
  final String? feedback;
  final String? filePath;
  final int? attempts;

  AssignmentModel({
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
    this.attempts,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'].toString().endsWith('Z') ? json['dueDate'] : json['dueDate'] + 'Z').toLocal() : DateTime.now(),
      maxPoints: (json['points'] as num?)?.toDouble() ?? (json['maxPoints'] as num?)?.toDouble() ?? 0.0,
      status: json['isSubmitted'] == true ? 'Submitted' : 'Pending',
      courseId: json['courseId'] as int?,
      instructorName: json['instructorName'] as String?,
      grade: (json['grade'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
      filePath: json['fileUrl'] as String? ?? json['filePath'] as String?,
      attempts: json['attempts'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'maxPoints': maxPoints,
      'status': status,
      'courseId': courseId,
      'instructorName': instructorName,
      'grade': grade,
      'feedback': feedback,
      'filePath': filePath,
      'attempts': attempts,
    };
  }

  AssignmentEntity toEntity() {
    return AssignmentEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      maxPoints: maxPoints,
      status: status,
      courseId: courseId,
      instructorName: instructorName,
      grade: grade,
      feedback: feedback,
      filePath: filePath,
      attempts: attempts ?? 0,
    );
  }
}
