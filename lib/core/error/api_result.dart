import 'failure.dart';

/// Sealed Result type returned by every RepositoryImpl and passed straight
/// through every UseCase. Pure Dart — no Flutter imports, no codegen.
///
/// Cubits unwrap this via [when] and never see a thrown exception.
sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = ApiSuccess<T>;
  const factory ApiResult.failure(Failure failure) = ApiFailure<T>;

  /// Pattern-match helper so call sites don't need a switch expression
  /// at every use.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    return switch (self) {
      ApiSuccess<T>(data: final data) => success(data),
      ApiFailure<T>(failure: final f) => failure(f),
    };
  }

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiFailure<T> extends ApiResult<T> {
  final Failure failure;
  const ApiFailure(this.failure);
}
