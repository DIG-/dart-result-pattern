import 'dart:async';

import 'package:result_pattern/src/async.dart';
import 'package:result_pattern/src/error/propagate.dart';
import 'package:result_pattern/src/error/unknown.dart';
import 'package:result_pattern/src/result.dart';
import 'package:safe_cast/safe_cast.dart';

FutureResult<R> _handleError<R>(
  ErrorOrExeption error,
  FutureOr<Result<R>> Function(ErrorOrExeption)? onError,
) async {
  if (onError == null) {
    return Result.failure(error);
  }
  try {
    return await onError(error);
  } on Exception catch (e) {
    return Result.failure(ResultPropagateError(e));
  } on Error catch (e) {
    return Result.failure(ResultPropagateError(e));
  } catch (e) {
    return Result.failure(ResultUnknownErrorException(e));
  }
}

extension FutureResultExtension<T> on FutureResult<T> {
  FutureResult<R> next<R>(
    FutureOr<Result<R>> Function(T) onValue, {
    FutureOr<Result<R>> Function(ErrorOrExeption)? onError,
  }) async {
    final result = await this;
    switch (result) {
      case ResultSuccess<T>():
        try {
          return await onValue(result.value);
        } on Exception catch (e) {
          return await _handleError(e, onError);
        } on Error catch (e) {
          return await _handleError(e, onError);
        } catch (e) {
          return Result.failure(ResultUnknownErrorException(e));
        }
      case ResultFailure<T>():
        return _handleError(result.error, onError);
    }
  }

  Future<T> get() async {
    final result = await this;
    return switch (result) {
      ResultSuccess<T>() => Future.value(result.value),
      ResultFailure<T>() => Future.error(
          result.error,
          Cast.asNullable<Error>(result.error)?.stackTrace,
        ),
    };
  }

  Future<T?> getOrNull() async {
    final result = await this;
    return switch (result) {
      ResultSuccess<T>() => result.value,
      ResultFailure<T>() => null,
    };
  }

  Future<T> getOrElse(FutureOr<T> Function() value) async =>
      (await getOrNull()) ?? await value();
}

extension ResultForFutureExtension<T> on Result<T> {
  FutureResult<T> toFuture() => Future.value(this);

  @pragma('vm:prefer-inline')
  FutureResult<R> next<R>(
    FutureOr<Result<R>> Function(T) onValue, {
    FutureOr<Result<R>> Function(ErrorOrExeption)? onError,
  }) =>
      toFuture().next(onValue, onError: onError);
}
