sealed class Failure implements Exception {
  const Failure([this.message]);

  final String? message;
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class BadRequestFailure extends Failure {
  const BadRequestFailure([super.message]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
