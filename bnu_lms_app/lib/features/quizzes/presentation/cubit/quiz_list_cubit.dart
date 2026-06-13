import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/get_quizzes_use_case.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../../../shared/services/signalr_service.dart';
import 'dart:async';

abstract class QuizListState {}
class QuizListInitial extends QuizListState {}
class QuizListLoading extends QuizListState {}
class QuizListLoaded extends QuizListState {
  final List<QuizEntity> quizzes;
  QuizListLoaded(this.quizzes);
}
class QuizListError extends QuizListState {
  final String message;
  QuizListError(this.message);
}

@injectable
class QuizListCubit extends Cubit<QuizListState> {
  final GetQuizzesUseCase getQuizzesUseCase;
  final SignalRService signalrService;
  StreamSubscription? _quizStreamSubscription;
  int? _currentCourseId;

  QuizListCubit(this.getQuizzesUseCase, this.signalrService) : super(QuizListInitial());

  void listenToRealTimeUpdates(int courseId) {
    _quizStreamSubscription?.cancel();
    _quizStreamSubscription = signalrService.quizStream.listen((event) {
      if (!isClosed) {
        loadQuizzes(courseId);
      }
    });
  }

  @override
  Future<void> close() {
    _quizStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> loadQuizzes(int courseId) async {
    _currentCourseId = courseId;
    emit(QuizListLoading());
    final result = await getQuizzesUseCase(courseId);
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(QuizListError(failure.message));
      },
      (quizzes) async {
        if (isClosed) return;
        emit(QuizListLoaded(quizzes));
        // Join the course group so the hub sends group-targeted events to this client.
        await signalrService.joinCourse(courseId);
        listenToRealTimeUpdates(courseId);
      },
    );
  }
}
