// lib/features/auth/data/mappers/auth_mapper.dart

import '../../domain/entities/auth_entity.dart';
import '../models/auth_model.dart';

/// Dart extension mapper — converts raw API model → clean domain entity.
extension AuthMapper on AuthModel {
  AuthEntity get toEntity => AuthEntity(
        token:      token,
        expiration: DateTime.parse(expiration),
        email:      email,
        role:       _parseRole(role),
        firstName:  firstName,
        lastName:   lastName,
      );

  UserRole _parseRole(String raw) => switch (raw.toLowerCase()) {
        'student'                          => UserRole.student,
        'instructor' || 'doctor'           => UserRole.instructor,
        'ta' || 'teachingassistant'        => UserRole.ta,
        _                                  => UserRole.unknown,
      };
}
