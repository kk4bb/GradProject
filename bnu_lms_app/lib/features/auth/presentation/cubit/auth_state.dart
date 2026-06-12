// lib/features/auth/presentation/cubit/auth_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  final AuthEntity auth;
  const AuthSuccess(this.auth);

  @override
  List<Object?> get props => [auth];
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
