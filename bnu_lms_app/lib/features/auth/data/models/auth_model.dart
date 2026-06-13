// lib/features/auth/data/models/auth_model.dart

/// Raw API response model — JSON lives only here.
class AuthModel {
  final String token;
  final String expiration;
  final String email;
  final String role;
  final String firstName;
  final String lastName;

  const AuthModel({
    required this.token,
    required this.expiration,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        token:      json['token']      as String,
        expiration: json['expiration'] as String,
        email:      json['email']      as String,
        role:       json['role']       as String,
        firstName:  json['firstName']  as String? ?? 'Welcome',
        lastName:   json['lastName']   as String? ?? '',
      );
}
