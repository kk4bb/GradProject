// lib/features/courses/presentation/cubit/course_details_cubit/course_details_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/course_entity.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../domain/use_cases/add_content_use_case.dart';
import '../../../domain/use_cases/add_lesson_use_case.dart';
import '../../../domain/use_cases/create_module_use_case.dart';
import '../../../domain/use_cases/get_course_details_use_case.dart';
import '../../../domain/use_cases/upload_content_use_case.dart';
import 'course_details_state.dart';

@injectable
class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final GetCourseDetailsUseCase _getCourseDetails;
  final CreateModuleUseCase _createModule;
  final AddLessonUseCase _addLesson;
  final AddContentUseCase _addContent;
  final UploadContentUseCase _uploadContent;
  final CourseRepository _courseRepository;

  CourseDetailEntity? _currentCourse;

  CourseDetailsCubit(
    this._getCourseDetails,
    this._createModule,
    this._addLesson,
    this._addContent,
    this._uploadContent,
    this._courseRepository,
  ) : super(const CourseDetailsInitial());

  Future<void> fetchCourseDetails(int id) async {
    emit(const CourseDetailsLoading());
    final result = await _getCourseDetails(id);
    result.fold(
      (failure) => emit(CourseDetailsError(failure.message)),
      (course) {
        _currentCourse = course;
        emit(CourseDetailsLoaded(course));
      },
    );
  }

  Future<void> createModule(int courseId, String title) async {
    if (_currentCourse == null) return;
    emit(CourseActionLoading(_currentCourse!));
    
    final result = await _createModule(courseId: courseId, title: title);
    result.fold(
      (failure) => emit(CourseActionError(failure.message, _currentCourse!)),
      (_) {
        emit(const CourseActionSuccess('Module created successfully'));
        // Re-fetch details to get updated lists
        fetchCourseDetails(courseId);
      },
    );
  }

  Future<void> addLesson(int moduleId, String title) async {
    if (_currentCourse == null) return;
    emit(CourseActionLoading(_currentCourse!));
    
    final result = await _addLesson(moduleId: moduleId, title: title);
    result.fold(
      (failure) => emit(CourseActionError(failure.message, _currentCourse!)),
      (_) {
        emit(const CourseActionSuccess('Lesson added successfully'));
        fetchCourseDetails(_currentCourse!.id);
      },
    );
  }

  Future<void> addContent(int lessonId, String type, String url) async {
    if (_currentCourse == null) return;
    emit(CourseActionLoading(_currentCourse!));
    
    final result = await _addContent(lessonId: lessonId, type: type, url: url);
    result.fold(
      (failure) => emit(CourseActionError(failure.message, _currentCourse!)),
      (_) {
        emit(const CourseActionSuccess('Content added successfully'));
        fetchCourseDetails(_currentCourse!.id);
      },
    );
  }

  Future<void> uploadContent({
    required int lessonId,
    required String contentType,
    required String filePath,
    required String fileName,
  }) async {
    if (_currentCourse == null) return;
    emit(CourseActionLoading(_currentCourse!));

    final result = await _uploadContent(
      lessonId: lessonId,
      contentType: contentType,
      filePath: filePath,
      fileName: fileName,
    );

    result.fold(
      (failure) => emit(CourseActionError(failure.message, _currentCourse!)),
      (_) {
        emit(const CourseActionSuccess('File uploaded successfully'));
        fetchCourseDetails(_currentCourse!.id);
      },
    );
  }

  Future<void> deleteContent(int contentId) async {
    if (_currentCourse == null) return;
    emit(CourseActionLoading(_currentCourse!));

    final result = await _courseRepository.deleteContent(contentId);
    result.fold(
      (failure) => emit(CourseActionError(failure.message, _currentCourse!)),
      (_) {
        emit(const CourseActionSuccess('Content deleted successfully'));
        fetchCourseDetails(_currentCourse!.id);
      },
    );
  }
}
