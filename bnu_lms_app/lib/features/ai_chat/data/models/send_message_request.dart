class SendMessageRequest {
  final int? sessionId;
  final int? courseId;
  final String content;
  final String? base64Image;

  SendMessageRequest({
    this.sessionId,
    this.courseId,
    required this.content,
    this.base64Image,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'courseId': courseId,
      'content': content,
      'base64Image': base64Image,
    };
  }
}
