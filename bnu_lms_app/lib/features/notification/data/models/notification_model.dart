class NotificationModel {
  final int id;
  final String title;
  final String message;
  final int type;
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;
  final String? senderName;
  final String? courseName;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
    this.senderName,
    this.courseName,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? 'Notification',
      message: json['message'] ?? '',
      type: json['type'],
      referenceId: json['referenceId'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      senderName: json['senderName'],
      courseName: json['courseName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'referenceId': referenceId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'senderName': senderName,
      'courseName': courseName,
    };
  }
}
