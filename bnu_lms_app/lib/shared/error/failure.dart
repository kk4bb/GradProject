// lib/shared/error/failure.dart

import 'package:equatable/equatable.dart';

/// Domain-level failure — returned in Left() by all repositories.
class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'Failure: $message';
}
