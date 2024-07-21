import 'package:result_pattern/src/result.dart';

typedef FutureResult<T> = Future<Result<T>>;
typedef AsyncResult<T> = FutureResult<T>;
