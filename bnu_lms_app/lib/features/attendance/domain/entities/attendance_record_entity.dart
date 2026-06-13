class AttendanceRecordEntity {
  final String studentId;
  final String studentName;
  final String sessionTitle; // "Lecture #1", "Section #2", etc.
  final DateTime scannedAt;
  final bool isPresent;
  final String? profilePictureUrl;

  const AttendanceRecordEntity({
    required this.studentId,
    required this.studentName,
    this.sessionTitle = '',
    required this.scannedAt,
    required this.isPresent,
    this.profilePictureUrl,
  });
}
