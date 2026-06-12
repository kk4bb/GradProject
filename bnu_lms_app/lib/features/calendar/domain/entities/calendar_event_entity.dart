import 'package:equatable/equatable.dart';

class CalendarEventEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String eventType; // "Assignment" | "Quiz"
  final int courseId;
  final String courseTitle;

  const CalendarEventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventType,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  List<Object?> get props => [id, title, eventDate, eventType, courseId];
}
