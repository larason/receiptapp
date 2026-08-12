/// An application error whose [message] is safe to show directly to the user.
class AppException implements Exception {
  const AppException(this.message, {this.code});

  /// Human-readable message suitable for display.
  final String message;

  /// Optional machine-readable error code for programmatic handling.
  final String? code;

  @override
  String toString() => message;
}
