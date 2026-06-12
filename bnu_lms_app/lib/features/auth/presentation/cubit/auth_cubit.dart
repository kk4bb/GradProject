import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import 'auth_state.dart';
import '../../../../shared/services/signalr_service.dart';
import '../../../../shared/di/injection.dart';
import '../../../notification/presentation/cubit/notification_cubit.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final SignalRService _signalRService;

  AuthCubit(this._loginUseCase, this._logoutUseCase, this._signalRService) : super(const AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(email: email, password: password);

    // fold: Left → AuthFailure | Right → AuthSuccess
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (auth) {
        _signalRService.init(auth.token);
        // Seed notifications globally so the bell badge updates immediately
        getIt<NotificationCubit>().getNotifications();
        emit(AuthSuccess(auth));
      },
    );
  }

  Future<void> logout() async {
    // 1. Clear local storage/tokens via the use case
    await _logoutUseCase();
    
    // 2. Clear SignalR connection if needed
    // _signalRService.stop(); // Optional but good practice

    // 3. Only emit if not closed
    if (!isClosed) {
      emit(const AuthUnauthenticated());
    }
  }
}
