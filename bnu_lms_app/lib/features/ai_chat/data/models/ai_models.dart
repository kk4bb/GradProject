class ChatSessionModel {
  final int id;
  final String title;
  final DateTime createdAt;

  const ChatSessionModel({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
      };
}

class ChatMessageModel {
  final int id;
  final String sender; // "User" or "AI"
  final String content;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.sender,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as int? ?? 0,
      sender: json['sender'] as String? ?? 'User',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  ChatMessageModel copyWith({
    int? id,
    String? sender,
    String? content,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
