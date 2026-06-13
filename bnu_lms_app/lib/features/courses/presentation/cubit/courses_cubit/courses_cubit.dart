// lib/features/courses/presentation/cubit/courses_cubit/courses_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/use_cases/get_enrolled_courses_use_case.dart';
import '../../../domain/use_cases/get_assigned_courses_use_case.dart';
import 'courses_state.dart';

@injectable
class CoursesCubit extends Cubit<CoursesState> {
  final GetEnrolledCoursesUseCase _getEnrolledCourses;
  final GetAssignedCoursesUseCase _getAssignedCourses;

  CoursesCubit(this._getEnrolledCourses, this._getAssignedCourses)
      : super(const CoursesInitial());

  Future<void> fetchEnrolledCourses() async {
    emit(const CoursesLoading());
    final result = await _getEnrolledCourses();
    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> fetchAssignedCourses() async {
    emit(const CoursesLoading());
    final result = await _getAssignedCourses();
    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }
}
