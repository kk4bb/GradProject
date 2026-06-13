import '../../domain/entities/attendance_session_entity.dart';

class AttendanceSessionModel extends AttendanceSessionEntity {
  const AttendanceSessionModel({
    required super.sessionId,
    required super.sessionTitle,
    required super.qrCodeToken,
    required super.expiresAt,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      sessionId: json['sessionId'] as int,
      sessionTitle: json['sessionTitle'] as String,
      qrCodeToken: json['qrCodeToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionTitle': sessionTitle,
      'qrCodeToken': qrCodeToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
