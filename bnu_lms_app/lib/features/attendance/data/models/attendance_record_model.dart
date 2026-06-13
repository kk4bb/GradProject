import '../../domain/entities/attendance_record_entity.dart';

class AttendanceRecordModel extends AttendanceRecordEntity {
  const AttendanceRecordModel({
    required super.studentId,
    required super.studentName,
    super.sessionTitle,
    required super.scannedAt,
    required super.isPresent,
    super.profilePictureUrl,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? 'Unknown Student',
      sessionTitle: json['sessionTitle'] as String? ?? '',
      scannedAt: json['scannedAt'] != null && json['scannedAt'] != "0001-01-01T00:00:00"
          ? DateTime.parse(json['scannedAt'] as String)
          : DateTime.now(),
      isPresent: json['isPresent'] as bool? ?? false,
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'sessionTitle': sessionTitle,
      'scannedAt': scannedAt.toIso8601String(),
      'isPresent': isPresent,
    };
  }
}
