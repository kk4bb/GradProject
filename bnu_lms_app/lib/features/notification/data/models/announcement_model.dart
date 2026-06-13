class AnnouncementModel {
  final int id;
  final int courseId;
  final String authorId;
  final String title;
  final String content;
  final String? targetSection;
  final int priority;
  final bool isPinned;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.courseId,
    required this.authorId,
    required this.title,
    required this.content,
    this.targetSection,
    required this.priority,
    required this.isPinned,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      courseId: json['courseId'],
      authorId: json['authorId'],
      title: json['title'],
      content: json['content'],
      targetSection: json['targetSection'],
      priority: json['priority'],
      isPinned: json['isPinned'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'authorId': authorId,
      'title': title,
      'content': content,
      'targetSection': targetSection,
      'priority': priority,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
