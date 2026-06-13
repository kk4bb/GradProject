// lib/features/auth/domain/entity/auth_entity.dart

import 'package:equatable/equatable.dart';

enum UserRole { student, instructor, ta, unknown }

extension UserRoleX on UserRole {
  bool get isStudent    => this == UserRole.student;
  bool get isInstructor => this == UserRole.instructor;
  bool get isTa         => this == UserRole.ta;
}

class AuthEntity extends Equatable {
  final String token;
  final DateTime expiration;
  final String email;
  final UserRole role;
  final String firstName;
  final String lastName;

  const AuthEntity({
    required this.token,
    required this.expiration,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [token, expiration, email, role, firstName, lastName];
}
