import '../../domain/entities/calendar_event_entity.dart';

class CalendarEventModel {
  final int id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String eventType;
  final int courseId;
  final String courseTitle;

  CalendarEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventType,
    required this.courseId,
    required this.courseTitle,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      eventDate: json['eventDate'] != null
          ? DateTime.parse(json['eventDate'].toString().endsWith('Z') ? json['eventDate'] : json['eventDate'] + 'Z').toLocal()
          : DateTime.now(),
      eventType: json['eventType'] as String? ?? 'Assignment',
      courseId: json['courseId'] as int? ?? 0,
      courseTitle: json['courseTitle'] as String? ?? '',
    );
  }

  CalendarEventEntity toEntity() {
    return CalendarEventEntity(
      id: id,
      title: title,
      description: description,
      eventDate: eventDate,
      eventType: eventType,
      courseId: courseId,
      courseTitle: courseTitle,
    );
  }
}
