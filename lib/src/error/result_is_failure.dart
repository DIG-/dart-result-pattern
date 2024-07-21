import 'package:result_pattern/src/result.dart';

final class ResultIsFailure extends Error {
  final ErrorOrExeption reason;
  ResultIsFailure(this.reason);

  @override
  String toString() => 'ResultIsFailure: $reason';
}
