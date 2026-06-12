import '../../domain/entities/grade_entity.dart';

abstract class GradesState {}

class GradesInitial extends GradesState {}

class GradesLoading extends GradesState {}

class GradesLoaded extends GradesState {
  final List<GradeEntity> courseGrades;
  final GradeEntity? currentStudentGrade;

  GradesLoaded({required this.courseGrades, this.currentStudentGrade});
}

class GradesError extends GradesState {
  final String message;

  GradesError(this.message);
}
