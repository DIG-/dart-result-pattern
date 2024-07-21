import 'package:result_pattern/result.dart';
import 'package:test/test.dart';

void main() {
  final sampleString = 'SampleString';
  final sampleError = ArgumentError.value(null);
  final sampleException = FormatException();

  group('ResultSuccess instance', () {
    test('Non-null value on non-null T', () {
      final result = ResultSuccess<String>(sampleString);
      expect(result.value, equals(sampleString));
    });
    test('Non-null value on null T', () {
      final result = ResultSuccess<String?>(sampleString);
      expect(result.value, isNotNull);
      expect(result.value, equals(sampleString));
    });
    test('Null value on null T', () {
      final result = ResultSuccess<String?>(null);
      expect(result.value, isNull);
    });
  });

  group('ResultFailure instance', () {
    test('With Error', () {
      final result = ResultFailure(sampleError);
      expect(result.error, isNotNull);
      expect(result.error, equals(sampleError));
    });
    test('With Exception', () {
      final result = ResultFailure(sampleException);
      expect(result.error, isNotNull);
      expect(result.error, equals(sampleException));
    });
    test('With not Error or Exception', () {
      try {
        ResultFailure(sampleString);
      } catch (e) {
        expect(e, isA<AssertionError>());
        return;
      }
      fail('Must throw');
    });
  });

  group('Result factory test', () {
    test('Check success factory', () {
      final result = Result.success(sampleString);
      expect(result, isNotNull);
      expect(result, isA<ResultSuccess>());
      expect((result as ResultSuccess).value, isNotNull);
      expect((result as ResultSuccess).value, equals(sampleString));
    });
    test('Check success factory T', () {
      expect(Result.success(sampleString), isA<ResultSuccess<String>>());
      expect(Result.success(42), isA<ResultSuccess<int>>());
      expect(Result.success({}), isA<ResultSuccess<Map>>());
      expect(Result.success({'a': 42}), isA<ResultSuccess<Map<String, int>>>());
      expect(Result.success([]), isA<ResultSuccess<List>>());
      expect(Result.success([42]), isA<ResultSuccess<List<int>>>());
    });
    test('Check failure factory', () {
      final result = Result.failure(sampleError);
      expect(result, isNotNull);
      expect(result, isA<ResultFailure>());
      result as ResultFailure;
      expect(result.error, isNotNull);
      expect(result.error, equals(sampleError));
    });
  });
}
