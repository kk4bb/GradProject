class StudentProfile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String faculty;
  final int academicYear;
  final int creditHours;
  final int enrolledCoursesCount;

  StudentProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.faculty,
    required this.academicYear,
    required this.creditHours,
    required this.enrolledCoursesCount,
  });

  String get fullName => '$firstName $lastName';

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      faculty: json['faculty'] ?? '',
      academicYear: json['academicYear'] ?? 0,
      creditHours: json['creditHours'] ?? 0,
      enrolledCoursesCount: json['enrolledCoursesCount'] ?? 0,
    );
  }
}
