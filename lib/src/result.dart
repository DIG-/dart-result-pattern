sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = ResultSuccess;
  const factory Result.failure(ErrorOrExeption error) = ResultFailure;
}

final class ResultSuccess<T> extends Result<T> {
  final T value;
  const ResultSuccess(this.value);

  @override
  int get hashCode => (runtimeType.hashCode * 31) + (value?.hashCode ?? 0);

  @override
  bool operator ==(Object other) =>
      other is ResultSuccess && other.value == value;

  @override
  String toString() => 'ResultSuccess(value=$value)';
}

final class ResultFailure<T> extends Result<T> {
  final ErrorOrExeption error;
  const ResultFailure(this.error)
      : assert(
          error is Error || error is Exception,
          'Error must be instance of Error or Exception. Found $error',
        );

  @override
  int get hashCode => (runtimeType.hashCode * 31) + error.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ResultFailure && other.error == error;

  @override
  String toString() => 'ResultFailure(error=$error)';
}

typedef ErrorOrExeption = Object;
