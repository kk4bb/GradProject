import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../entities/calendar_event_entity.dart';

abstract class CalendarRepository {
  Future<Either<Failure, List<CalendarEventEntity>>> getCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
  });
}
