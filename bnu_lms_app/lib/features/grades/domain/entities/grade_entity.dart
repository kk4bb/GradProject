class GradeEntity {
  final int id;
  final String studentId;
  final String studentName;
  final String? studentAvatarUrl;
  final int courseId;
  final double quizzesTotal;
  final double assignmentsTotal;
  final double attendanceTotal;
  final double projectGrade;
  final double midterm1;
  final double midterm2;
  final double finalExam;
  final bool isTermWorkPublished;
  final double totalGrade;

  GradeEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.studentAvatarUrl,
    required this.courseId,
    required this.quizzesTotal,
    required this.assignmentsTotal,
    required this.attendanceTotal,
    required this.projectGrade,
    required this.midterm1,
    required this.midterm2,
    required this.finalExam,
    required this.isTermWorkPublished,
    required this.totalGrade,
  });
}
