class NetworkFailure implements Exception {
  final String message;
  NetworkFailure(this.message);

  @override
  String toString() => 'NetworkFailure: $message';
}

class CacheFailure implements Exception {
  final String message;
  CacheFailure(this.message);
  @override
  String toString() => 'CacheFailure: $message';
}

class NotFoundFailure implements Exception {
  final String message;
  NotFoundFailure(this.message);
  @override
  String toString() => 'NotFoundFailure: $message';
}

class ValidationFailure implements Exception {
  final String message;
  ValidationFailure(this.message);
  @override
  String toString() => 'ValidationFailure: $message';
}

class UnknownFailure implements Exception {
  final String message;
  UnknownFailure(this.message);
  @override
  String toString() => 'UnknownFailure: $message';
}
