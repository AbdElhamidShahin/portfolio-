/// Base sealed type for all domain/data-layer failures.
///
/// Pure Dart — no Flutter imports. RepositoryImpl is responsible for
/// catching raw exceptions and mapping them to one of these.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// Connectivity / request-level failure (timeouts, no internet, DNS, etc).
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred.']);
}

/// Non-2xx response or malformed payload from a remote source.
final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred.']);
}

/// Requested resource could not be found (e.g. missing id).
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Requested resource was not found.']);
}

/// Data existed but failed validation or parsing (JSON/shape mismatch).
final class InvalidDataFailure extends Failure {
  const InvalidDataFailure([super.message = 'Invalid data received.']);
}

/// Fallback for anything that doesn't fit the above categories.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
