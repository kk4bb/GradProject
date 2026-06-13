// lib/features/courses/presentation/cubit/courses_cubit/courses_state.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/course_entity.dart';

sealed class CoursesState extends Equatable {
  const CoursesState();
  @override
  List<Object?> get props => [];
}

final class CoursesInitial extends CoursesState {
  const CoursesInitial();
}

final class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

final class CoursesLoaded extends CoursesState {
  final List<CourseSummaryEntity> courses;
  const CoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

final class CoursesError extends CoursesState {
  final String message;
  const CoursesError(this.message);

  @override
  List<Object?> get props => [message];
}
