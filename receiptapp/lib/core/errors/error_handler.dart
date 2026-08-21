import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Maps any caught error to a clear, user-friendly message.
///
/// Unknown errors fall back to a generic message so the UI never displays a
/// raw exception to the user.
String friendlyErrorMessage(Object error) {
  if (error is AppException) return error.message;
  if (error is SocketException) {
    return 'No internet connection. Please check your connection and try again.';
  }
  if (error is TimeoutException) {
    return 'The request timed out. Please try again.';
  }
  return 'Something went wrong. Please try again.';
}

/// Installs global handlers so uncaught errors never crash the app silently.
void configureGlobalErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Uncaught Flutter error: ${details.exception}');
    debugPrint('${details.stack}');
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('Uncaught platform error: $error');
    debugPrint('$stack');
    return true;
  };
}
