import 'dart:math';

import 'package:result_pattern/result.dart';

Result<String> taskThatCanFail() {
  if (Random().nextInt(6) == 0) {
    return Result.failure(Error());
  }
  return Result.success('It is success');
}

void main() {
  taskThatCanFail().then((str) => Result.success(str.length)).fold((value) {
    print('Success: $value');
  }, onError: (error) {
    print('Error: $error');
  });
}
