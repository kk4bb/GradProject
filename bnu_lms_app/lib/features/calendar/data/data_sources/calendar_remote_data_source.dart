import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/config/api_constants.dart';
import '../models/calendar_event_model.dart';

abstract class CalendarRemoteDataSource {
  Future<List<CalendarEventModel>> getCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
  });
}

@LazySingleton(as: CalendarRemoteDataSource)
class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  final Dio dio;

  CalendarRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CalendarEventModel>> getCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await dio.get(
      ApiConstants.calendar,
      queryParameters: {
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
      },
    );
    return (response.data as List)
        .map((json) => CalendarEventModel.fromJson(json))
        .toList();
  }
}
