import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/entities/grade_entity.dart';

abstract class GradesRepository {
  Future<Either<Failure, GradeEntity>> getStudentGrades(int courseId, String studentId);
  Future<Either<Failure, List<GradeEntity>>> getCourseGrades(int courseId);
  Future<Either<Failure, GradeEntity>> updateGrades(int courseId, String studentId, Map<String, dynamic> updateData);
  Future<Either<Failure, void>> publishTermWork(int courseId);
  Future<Either<Failure, void>> unlockTermWork(int courseId);
}
