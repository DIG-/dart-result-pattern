class ErrorAsException implements Exception {
  final Error error;
  const ErrorAsException(this.error);

  @override
  String toString() => error.toString();
}

class ExceptionAsError extends Error {
  final Exception exception;
  ExceptionAsError(this.exception);

  @override
  String toString() => exception.toString();
}
