final class ResultUnknownErrorException implements Exception {
  final dynamic cause;
  final StackTrace stackTrace;
  const ResultUnknownErrorException._(this.cause, {required this.stackTrace});

  ResultUnknownErrorException(dynamic cause)
      : this._(cause, stackTrace: StackTrace.current);

  @override
  bool operator ==(Object other) =>
      other is ResultUnknownErrorException && other.cause == cause;

  @override
  int get hashCode => (runtimeType.hashCode * 31) + cause.hashCode;

  @override
  String toString() =>
      'ResultUnknownErrorException: Result expects Error or Exception, but ${cause?.runtimeType} was found';
}
