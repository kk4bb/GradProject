// lib/shared/error/remote_exception.dart

/// Thrown by remote data sources when the API returns an error.
/// Caught by the repository and converted into a Left(Failure).
class RemoteException implements Exception {
  final String message;
  const RemoteException({required this.message});

  @override
  String toString() => 'RemoteException: $message';
}
