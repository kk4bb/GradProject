// lib/features/courses/presentation/cubit/course_details_cubit/course_details_state.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/course_entity.dart';

sealed class CourseDetailsState extends Equatable {
  const CourseDetailsState();
  @override
  List<Object?> get props => [];
}

final class CourseDetailsInitial extends CourseDetailsState {
  const CourseDetailsInitial();
}

final class CourseDetailsLoading extends CourseDetailsState {
  const CourseDetailsLoading();
}

final class CourseDetailsLoaded extends CourseDetailsState {
  final CourseDetailEntity course;
  const CourseDetailsLoaded(this.course);

  @override
  List<Object?> get props => [course];
}

final class CourseDetailsError extends CourseDetailsState {
  final String message;
  const CourseDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Actions States (Adding Module/Lesson/Content) ──────────────────────────

final class CourseActionLoading extends CourseDetailsState {
  // We keep the old course data so UI doesn't flicker entirely
  final CourseDetailEntity course;
  const CourseActionLoading(this.course);

  @override
  List<Object?> get props => [course];
}

final class CourseActionSuccess extends CourseDetailsState {
  final String successMessage;
  const CourseActionSuccess(this.successMessage);

  @override
  List<Object?> get props => [successMessage];
}

final class CourseActionError extends CourseDetailsState {
  final String message;
  final CourseDetailEntity course; // keep old data
  const CourseActionError(this.message, this.course);

  @override
  List<Object?> get props => [message, course];
}
