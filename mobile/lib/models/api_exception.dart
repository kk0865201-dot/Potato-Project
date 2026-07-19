enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  unknown,
}

/// Single exception type thrown by the networking layer, so screens only
/// ever have to catch one thing and show a friendly message.
class ApiException implements Exception {
  final ApiErrorType type;
  final int? statusCode;

  /// Message coming from the Laravel `{success:false, message: ...}` envelope
  /// (e.g. "Invalid email or password."). Null for connection problems.
  final String? serverMessage;

  /// Field-level validation errors from a 422 response.
  final Map<String, dynamic>? errors;

  const ApiException({
    required this.type,
    this.statusCode,
    this.serverMessage,
    this.errors,
  });

  /// Translation key for a generic, localized fallback message.
  String get translationKey {
    switch (type) {
      case ApiErrorType.network:
        return 'error_no_internet';
      case ApiErrorType.timeout:
        return 'error_timeout';
      case ApiErrorType.unauthorized:
        return 'error_unauthorized';
      case ApiErrorType.forbidden:
        return 'error_forbidden';
      case ApiErrorType.notFound:
        return 'error_not_found';
      case ApiErrorType.validation:
        return 'error_validation';
      case ApiErrorType.server:
        return 'error_server';
      case ApiErrorType.unknown:
        return 'error_unknown';
    }
  }

  @override
  String toString() =>
      'ApiException($type, status: $statusCode, message: $serverMessage)';
}
