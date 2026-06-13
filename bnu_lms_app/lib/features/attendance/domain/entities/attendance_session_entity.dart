class AttendanceSessionEntity {
  final int sessionId;
  final String sessionTitle;
  final String qrCodeToken;
  final DateTime expiresAt;

  const AttendanceSessionEntity({
    required this.sessionId,
    required this.sessionTitle,
    required this.qrCodeToken,
    required this.expiresAt,
  });
}
