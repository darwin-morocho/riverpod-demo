import 'either/either.dart';
import 'failures/http_request_failure.dart';

typedef Json = Map<String, dynamic>;
typedef HttpFuture<T> = Future<Either<HttpRequestFailure, T>>;
