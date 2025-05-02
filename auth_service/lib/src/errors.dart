class NotAuthenticatedException implements Exception {
  final Object? error;

  NotAuthenticatedException([this.error]);
}

class InternalError implements Exception {
  final Object? error;

  InternalError([this.error]);
}
