import 'dart:io';

import 'package:http/http.dart';

import '../../domain/either/either.dart';
import '../../domain/failures/http_request_failure.dart';
import '../../domain/typedefs.dart';
import '../http/http.dart';

HttpFuture<T> performHttpRequest<T>(
  Future<HttpResult<T>> future,
) async {
  final result = await future;
  if (result is HttpFailure<T>) {
    HttpRequestFailure? failure;
    final statusCode = result.statusCode;
    final data = result.data;

    if (statusCode != null) {
      if (statusCode == 404) {
        failure = const HttpRequestFailure.notFound();
      } else if (statusCode == 400) {
        failure = const HttpRequestFailure.badRequest();
      } else if (statusCode >= 500) {
        failure = const HttpRequestFailure.server();
      }
    } else if (data is SocketException || data is ClientException) {
      failure = const HttpRequestFailure.network();
    }

    return Either.left(
      failure ?? const HttpRequestFailure.unknown(),
    );
  }

  return Either.right((result as HttpSuccess<T>).data);
}

List<T> buildList<T>(List list, T Function(dynamic) mapper) =>
    list.map(mapper).toList();
