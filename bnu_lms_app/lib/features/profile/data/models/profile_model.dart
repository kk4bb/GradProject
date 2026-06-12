class ProfileModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? faculty;
  final int? academicYear;
  final int? creditHours;
  final int? enrolledCoursesCount;
  final double? gpa;
  final int? rank;
  final String? studentId;
  final String? role;
  final String? profilePictureUrl;

  ProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.faculty,
    this.academicYear,
    this.creditHours,
    this.enrolledCoursesCount,
    this.gpa,
    this.rank,
    this.studentId,
    this.role,
    this.profilePictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      faculty: json['faculty'] as String?,
      academicYear: json['academicYear'] as int?,
      creditHours: json['creditHours'] as int?,
      enrolledCoursesCount: json['enrolledCoursesCount'] as int?,
      gpa: (json['gpa'] as num?)?.toDouble(),
      rank: json['rank'] as int?,
      studentId: json['studentId'] as String?,
      role: json['role'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'faculty': faculty,
      'academicYear': academicYear,
      'creditHours': creditHours,
      'enrolledCoursesCount': enrolledCoursesCount,
      'gpa': gpa,
      'rank': rank,
      'studentId': studentId,
      'role': role,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
