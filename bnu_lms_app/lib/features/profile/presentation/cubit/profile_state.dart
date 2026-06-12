import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
