// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/assignments/data/data_sources/remote/assignment_remote_data_source.dart'
    as _i1042;
import '../../features/assignments/data/repositories/assignment_repository_impl.dart'
    as _i58;
import '../../features/assignments/domain/repositories/assignment_repository.dart'
    as _i928;
import '../../features/assignments/presentation/manager/instructor/assignments_cubit.dart'
    as _i407;
import '../../features/assignments/presentation/manager/instructor/grading_cubit.dart'
    as _i733;
import '../../features/assignments/presentation/manager/student/student_assignments_cubit.dart'
    as _i633;
import '../../features/assignments/presentation/manager/submission/assignment_submission_cubit.dart'
    as _i957;
import '../../features/attendance/data/data_sources/remote/attendance_remote_data_source.dart'
    as _i913;
import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i719;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i477;
import '../../features/attendance/presentation/cubit/instructor_attendance_cubit.dart'
    as _i666;
import '../../features/attendance/presentation/cubit/student_attendance_cubit.dart'
    as _i386;
import '../../features/auth/data/data_sources/remote/auth_remote_data_source.dart'
    as _i432;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/logout_use_case.dart' as _i698;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/calendar/data/data_sources/calendar_remote_data_source.dart'
    as _i816;
import '../../features/calendar/data/repositories/calendar_repository_impl.dart'
    as _i712;
import '../../features/calendar/domain/repositories/calendar_repository.dart'
    as _i241;
import '../../features/calendar/presentation/cubit/calendar_cubit.dart'
    as _i131;
import '../../features/courses/data/data_sources/remote/course_remote_data_source.dart'
    as _i598;
import '../../features/courses/data/repositories/course_repository_impl.dart'
    as _i657;
import '../../features/courses/domain/repositories/course_repository.dart'
    as _i749;
import '../../features/courses/domain/use_cases/add_content_use_case.dart'
    as _i448;
import '../../features/courses/domain/use_cases/add_lesson_use_case.dart'
    as _i113;
import '../../features/courses/domain/use_cases/create_module_use_case.dart'
    as _i865;
import '../../features/courses/domain/use_cases/get_assigned_courses_use_case.dart'
    as _i26;
import '../../features/courses/domain/use_cases/get_course_details_use_case.dart'
    as _i1055;
import '../../features/courses/domain/use_cases/get_enrolled_courses_use_case.dart'
    as _i773;
import '../../features/courses/presentation/cubit/course_details_cubit/course_details_cubit.dart'
    as _i445;
import '../../features/courses/presentation/cubit/courses_cubit/courses_cubit.dart'
    as _i382;
import '../../features/grades/data/data_sources/remote/grades_remote_data_source.dart'
    as _i474;
import '../../features/grades/data/repositories/grades_repository_impl.dart'
    as _i118;
import '../../features/grades/domain/repositories/grades_repository.dart'
    as _i438;
import '../../features/grades/presentation/cubit/grades_cubit.dart' as _i254;
import '../../features/notification/data/data_sources/remote/notification_remote_data_source.dart'
    as _i696;
import '../../features/notification/data/repositories/notification_repository_impl.dart'
    as _i407;
import '../../features/notification/domain/repositories/notification_repository.dart'
    as _i630;
import '../../features/notification/presentation/cubit/notification_cubit.dart'
    as _i369;
import '../../features/profile/data/data_sources/remote/profile_remote_data_source.dart'
    as _i683;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/use_cases/get_my_profile_use_case.dart'
    as _i763;
import '../../features/profile/domain/use_cases/upload_profile_picture_use_case.dart'
    as _i674;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/quizzes/data/data_sources/remote/quiz_remote_data_source.dart'
    as _i766;
import '../../features/quizzes/data/data_sources/remote/quiz_signalr_data_source.dart'
    as _i27;
import '../../features/quizzes/data/repositories/quiz_repository_impl.dart'
    as _i983;
import '../../features/quizzes/domain/repositories/quiz_repository.dart'
    as _i950;
import '../../features/quizzes/domain/use_cases/create_quiz_use_case.dart'
    as _i911;
import '../../features/quizzes/domain/use_cases/get_quiz_attempts_use_case.dart'
    as _i0;
import '../../features/quizzes/domain/use_cases/get_quiz_for_taking_use_case.dart'
    as _i927;
import '../../features/quizzes/domain/use_cases/get_quizzes_use_case.dart'
    as _i306;
import '../../features/quizzes/domain/use_cases/get_student_attempt_use_case.dart'
    as _i409;
import '../../features/quizzes/domain/use_cases/grade_essay_use_case.dart'
    as _i346;
import '../../features/quizzes/domain/use_cases/publish_grades_use_case.dart'
    as _i878;
import '../../features/quizzes/domain/use_cases/submit_quiz_use_case.dart'
    as _i829;
import '../../features/quizzes/domain/use_cases/update_quiz_use_case.dart'
    as _i107;
import '../../features/quizzes/presentation/cubit/quiz_attempts_cubit.dart'
    as _i954;
import '../../features/quizzes/presentation/cubit/quiz_grading_cubit.dart'
    as _i534;
import '../../features/quizzes/presentation/cubit/quiz_list_cubit.dart'
    as _i621;
import '../../features/quizzes/presentation/cubit/quiz_results_cubit.dart'
    as _i688;
import '../../features/quizzes/presentation/cubit/quiz_taking_cubit.dart'
    as _i764;
import '../services/signalr_service.dart' as _i320;
import 'dio_module.dart' as _i1045;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.singleton<_i320.SignalRService>(() => _i320.SignalRService());
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => dioModule.secureStorage);
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i432.AuthRemoteDataSource>(
      () => _i432.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i696.NotificationRemoteDataSource>(
      () => _i696.NotificationRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i432.AuthRemoteDataSource>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i630.NotificationRepository>(
      () => _i407.NotificationRepositoryImpl(
        remoteDataSource: gh<_i696.NotificationRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i27.QuizSignalrDataSource>(
      () => _i27.QuizSignalrDataSourceImpl(),
    );
    gh.lazySingleton<_i766.QuizRemoteDataSource>(
      () => _i766.QuizRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1042.AssignmentRemoteDataSource>(
      () => _i1042.AssignmentRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i816.CalendarRemoteDataSource>(
      () => _i816.CalendarRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i913.AttendanceRemoteDataSource>(
      () => _i913.AttendanceRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i241.CalendarRepository>(
      () => _i712.CalendarRepositoryImpl(gh<_i816.CalendarRemoteDataSource>()),
    );
    gh.factory<_i474.GradesRemoteDataSource>(
      () => _i474.GradesRemoteDataSourceImpl(
        dio: gh<_i361.Dio>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i438.GradesRepository>(
      () => _i118.GradesRepositoryImpl(
        remoteDataSource: gh<_i474.GradesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i477.AttendanceRepository>(
      () => _i719.AttendanceRepositoryImpl(
        gh<_i913.AttendanceRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i369.NotificationCubit>(
      () => _i369.NotificationCubit(
        repository: gh<_i630.NotificationRepository>(),
        signalRService: gh<_i320.SignalRService>(),
      ),
    );
    gh.factory<_i254.GradesCubit>(
      () => _i254.GradesCubit(
        gh<_i438.GradesRepository>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.lazySingleton<_i698.LogoutUseCase>(
      () => _i698.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i928.AssignmentRepository>(
      () => _i58.AssignmentRepositoryImpl(
        gh<_i1042.AssignmentRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i733.GradingCubit>(
      () => _i733.GradingCubit(gh<_i928.AssignmentRepository>()),
    );
    gh.factory<_i957.AssignmentSubmissionCubit>(
      () => _i957.AssignmentSubmissionCubit(gh<_i928.AssignmentRepository>()),
    );
    gh.lazySingleton<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        gh<_i1038.LoginUseCase>(),
        gh<_i698.LogoutUseCase>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.lazySingleton<_i950.QuizRepository>(
      () => _i983.QuizRepositoryImpl(gh<_i766.QuizRemoteDataSource>()),
    );
    gh.lazySingleton<_i683.ProfileRemoteDataSource>(
      () => _i683.ProfileRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i598.CourseRemoteDataSource>(
      () => _i598.CourseRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i911.CreateQuizUseCase>(
      () => _i911.CreateQuizUseCase(gh<_i950.QuizRepository>()),
    );
    gh.factory<_i0.GetQuizAttemptsUseCase>(
      () => _i0.GetQuizAttemptsUseCase(gh<_i950.QuizRepository>()),
    );
    gh.factory<_i927.GetQuizForTakingUseCase>(
      () => _i927.GetQuizForTakingUseCase(gh<_i950.QuizRepository>()),
    );
    gh.factory<_i409.GetStudentAttemptUseCase>(
      () => _i409.GetStudentAttemptUseCase(gh<_i950.QuizRepository>()),
    );
    gh.factory<_i107.UpdateQuizUseCase>(
      () => _i107.UpdateQuizUseCase(gh<_i950.QuizRepository>()),
    );
    gh.lazySingleton<_i306.GetQuizzesUseCase>(
      () => _i306.GetQuizzesUseCase(gh<_i950.QuizRepository>()),
    );
    gh.lazySingleton<_i346.GradeEssayUseCase>(
      () => _i346.GradeEssayUseCase(gh<_i950.QuizRepository>()),
    );
    gh.lazySingleton<_i878.PublishGradesUseCase>(
      () => _i878.PublishGradesUseCase(gh<_i950.QuizRepository>()),
    );
    gh.lazySingleton<_i829.SubmitQuizUseCase>(
      () => _i829.SubmitQuizUseCase(gh<_i950.QuizRepository>()),
    );
    gh.factory<_i666.InstructorAttendanceCubit>(
      () => _i666.InstructorAttendanceCubit(gh<_i477.AttendanceRepository>()),
    );
    gh.factory<_i386.StudentAttendanceCubit>(
      () => _i386.StudentAttendanceCubit(gh<_i477.AttendanceRepository>()),
    );
    gh.factory<_i954.QuizAttemptsCubit>(
      () => _i954.QuizAttemptsCubit(gh<_i0.GetQuizAttemptsUseCase>()),
    );
    gh.factory<_i131.CalendarCubit>(
      () => _i131.CalendarCubit(gh<_i241.CalendarRepository>()),
    );
    gh.factory<_i534.QuizGradingCubit>(
      () => _i534.QuizGradingCubit(
        gh<_i346.GradeEssayUseCase>(),
        gh<_i878.PublishGradesUseCase>(),
        gh<_i911.CreateQuizUseCase>(),
      ),
    );
    gh.lazySingleton<_i749.CourseRepository>(
      () => _i657.CourseRepositoryImpl(gh<_i598.CourseRemoteDataSource>()),
    );
    gh.factory<_i407.AssignmentsCubit>(
      () => _i407.AssignmentsCubit(
        gh<_i928.AssignmentRepository>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.factory<_i633.StudentAssignmentsCubit>(
      () => _i633.StudentAssignmentsCubit(
        gh<_i928.AssignmentRepository>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(
        remoteDataSource: gh<_i683.ProfileRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i448.AddContentUseCase>(
      () => _i448.AddContentUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i113.AddLessonUseCase>(
      () => _i113.AddLessonUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i865.CreateModuleUseCase>(
      () => _i865.CreateModuleUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i26.GetAssignedCoursesUseCase>(
      () => _i26.GetAssignedCoursesUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i1055.GetCourseDetailsUseCase>(
      () => _i1055.GetCourseDetailsUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i773.GetEnrolledCoursesUseCase>(
      () => _i773.GetEnrolledCoursesUseCase(gh<_i749.CourseRepository>()),
    );
    gh.lazySingleton<_i763.GetMyProfileUseCase>(
      () => _i763.GetMyProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.lazySingleton<_i674.UploadProfilePictureUseCase>(
      () => _i674.UploadProfilePictureUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i764.QuizTakingCubit>(
      () => _i764.QuizTakingCubit(
        gh<_i829.SubmitQuizUseCase>(),
        gh<_i927.GetQuizForTakingUseCase>(),
      ),
    );
    gh.factory<_i382.CoursesCubit>(
      () => _i382.CoursesCubit(
        gh<_i773.GetEnrolledCoursesUseCase>(),
        gh<_i26.GetAssignedCoursesUseCase>(),
      ),
    );
    gh.factory<_i621.QuizListCubit>(
      () => _i621.QuizListCubit(
        gh<_i306.GetQuizzesUseCase>(),
        gh<_i320.SignalRService>(),
      ),
    );
    gh.factory<_i688.QuizResultsCubit>(
      () => _i688.QuizResultsCubit(gh<_i409.GetStudentAttemptUseCase>()),
    );
    gh.factory<_i445.CourseDetailsCubit>(
      () => _i445.CourseDetailsCubit(
        gh<_i1055.GetCourseDetailsUseCase>(),
        gh<_i865.CreateModuleUseCase>(),
        gh<_i113.AddLessonUseCase>(),
        gh<_i448.AddContentUseCase>(),
      ),
    );
    gh.lazySingleton<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(
        gh<_i763.GetMyProfileUseCase>(),
        gh<_i674.UploadProfilePictureUseCase>(),
      ),
    );
    return this;
  }
}

class _$DioModule extends _i1045.DioModule {}
