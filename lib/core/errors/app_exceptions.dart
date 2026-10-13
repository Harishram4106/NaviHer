/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException(code: $code, message: $message, details: $details)';
}

/// Thrown when a user is not authenticated but tries to access a protected resource.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'User is not authenticated.'])
      : super(code: 'unauthorized');
}

/// Thrown when a requested resource is not found (e.g., no profile found).
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.'])
      : super(code: 'not_found');
}

/// Thrown for network or connection issues.
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network connection failed.'])
      : super(code: 'network_error');
}

/// Thrown when the backend (e.g., Supabase) returns an error.
class BackendException extends AppException {
  const BackendException(super.message, {String? code, super.details})
      : super(code: code ?? 'backend_error');
}
