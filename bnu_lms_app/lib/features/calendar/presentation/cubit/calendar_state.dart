import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/calendar_event_entity.dart';

part 'calendar_state.freezed.dart';

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState.initial() = _Initial;
  const factory CalendarState.loading() = _Loading;
  const factory CalendarState.loaded(List<CalendarEventEntity> events) = _Loaded;
  const factory CalendarState.error(String message) = _Error;
}
