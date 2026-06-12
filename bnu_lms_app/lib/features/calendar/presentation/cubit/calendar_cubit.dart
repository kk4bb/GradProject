import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/repositories/calendar_repository.dart';
import 'calendar_state.dart';

@injectable
class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepository _repository;

  CalendarCubit(this._repository) : super(const CalendarState.initial());

  Future<void> fetchEvents({required DateTime startDate, required DateTime endDate}) async {
    emit(const CalendarState.loading());
    final result = await _repository.getCalendarEvents(
      startDate: startDate,
      endDate: endDate,
    );
    result.fold(
      (failure) => emit(CalendarState.error(failure.message)),
      (events) => emit(CalendarState.loaded(events)),
    );
  }

  /// Returns only the events whose [eventDate] falls on the given [day].
  List<CalendarEventEntity> eventsForDay(
      List<CalendarEventEntity> allEvents, DateTime day) {
    return allEvents.where((e) =>
      e.eventDate.year == day.year &&
      e.eventDate.month == day.month &&
      e.eventDate.day == day.day,
    ).toList();
  }
}
