import 'package:result_pattern/src/result.dart';

final class ResultPropagateError implements Error {
  final ErrorOrExeption cause;
  @override
  final StackTrace stackTrace;
  const ResultPropagateError._(this.cause, {required this.stackTrace})
      : assert(
          cause is Error || cause is Exception,
          'Cause must be Error or Exception. Found $cause',
        );

  ResultPropagateError(ErrorOrExeption cause)
      : this._(cause, stackTrace: StackTrace.current);

  @override
  bool operator ==(Object other) =>
      other is ResultPropagateError && other.cause == cause;

  @override
  int get hashCode => (runtimeType.hashCode * 31) + cause.hashCode;

  @override
  String toString() => 'ResultPropagateError(cause=$cause)';
}
