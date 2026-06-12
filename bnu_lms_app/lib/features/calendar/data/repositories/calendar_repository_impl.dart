import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../data_sources/calendar_remote_data_source.dart';

@LazySingleton(as: CalendarRepository)
class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource _remoteDataSource;

  CalendarRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CalendarEventEntity>>> getCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final models = await _remoteDataSource.getCalendarEvents(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
