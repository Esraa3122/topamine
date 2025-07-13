import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.freezed.dart';

@Freezed()
abstract class DataResult<T> with _$DataResult<T> {
  const factory DataResult.success(T data) = Success<T>;
  const factory DataResult.failure(String errorHandler) = Failure<T>;
}
