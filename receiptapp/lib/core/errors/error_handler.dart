import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Maps any caught error to a clear, user-friendly message.
///
/// Unknown errors fall back to a generic message so the UI never displays a
/// raw exception to the user.
String friendlyErrorMessage(Object error) {
  if (error is AppException) return error.message;
  if (error is FirebaseAuthException) return _authErrorMessage(error);
  if (error is FirebaseException) return _firestoreErrorMessage(error);
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

String _authErrorMessage(FirebaseAuthException error) {
  switch (error.code) {
    case 'user-not-found':
    case 'wrong-password':
      return 'Invalid credentials. Please check your details and try again.';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'user-disabled':
      return 'This account has been disabled. Contact the administrator.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    default:
      return 'Sign-in failed. Please try again.';
  }
}

String _firestoreErrorMessage(FirebaseException error) {
  switch (error.code) {
    case 'permission-denied':
      return 'You do not have permission to perform this action.';
    case 'unavailable':
      return 'The server is unreachable. Check your connection and try again.';
    case 'not-found':
      return 'The requested receipt could not be found. It may have been deleted.';
    case 'already-exists':
      return 'A receipt with this identifier already exists.';
    default:
      return 'A database error occurred. Please try again.';
  }
}
