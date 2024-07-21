import 'package:result_pattern/src/error/propagate.dart';
import 'package:result_pattern/src/error/result_is_failure.dart';
import 'package:result_pattern/src/error/unknown.dart';
import 'package:result_pattern/src/error/wrapper.dart';
import 'package:result_pattern/src/result.dart';
import 'package:safe_cast/safe_cast.dart';

Result<R> _handleError<R>(
  ErrorOrExeption error,
  Result<R> Function(ErrorOrExeption)? onError,
) {
  if (onError == null) {
    return Result.failure(error);
  }
  try {
    return onError(error);
  } on Exception catch (e) {
    return Result.failure(ResultPropagateError(e));
  } on Error catch (e) {
    return Result.failure(ResultPropagateError(e));
  } catch (e) {
    return Result.failure(ResultUnknownErrorException(e));
  }
}

extension ResultExtension<T> on Result<T> {
  Result<R> then<R>(
    Result<R> Function(T) onValue, {
    Result<R> Function(ErrorOrExeption)? onError,
  }) {
    final result = this;
    switch (result) {
      case ResultSuccess<T>():
        try {
          return onValue(result.value);
        } on Exception catch (e) {
          return _handleError(e, onError);
        } on Error catch (e) {
          return _handleError(e, onError);
        } catch (e) {
          return Result.failure(ResultUnknownErrorException(e));
        }
      case ResultFailure<T>():
        return _handleError(result.error, onError);
    }
  }

  R fold<R>(
    R Function(T) onValue, {
    required R Function(ErrorOrExeption) onError,
  }) {
    final result = this;
    switch (result) {
      case ResultSuccess<T>():
        try {
          return onValue(result.value);
        } on Exception catch (e) {
          return onError(e);
        } on Error catch (e) {
          return onError(e);
        } catch (e) {
          return onError(ResultUnknownErrorException(e));
        }
      case ResultFailure<T>():
        return onError(result.error);
    }
  }

  T get() {
    final result = this;
    return switch (result) {
      ResultSuccess<T>() => result.value,
      ResultFailure<T>() => throw ResultIsFailure(result.error),
    };
  }

  T? getOrNull() {
    final result = this;
    return switch (result) {
      ResultSuccess<T>() => result.value,
      ResultFailure<T>() => null,
    };
  }

  @pragma('vm:prefer-inline')
  T getOrElse(T Function() value) => getOrNull() ?? value();

  @pragma('vm:prefer-inline')
  bool get isSuccess => this is ResultSuccess;

  @pragma('vm:prefer-inline')
  bool get isFailure => this is ResultFailure;
}

extension ResultFailureExtension<T> on ResultFailure<T> {
  Exception getException() =>
      Cast.asNullable<Exception>(error) ?? ErrorAsException(error as Error);

  Error getError() =>
      Cast.asNullable<Error>(error) ?? ExceptionAsError(error as Exception);
}
