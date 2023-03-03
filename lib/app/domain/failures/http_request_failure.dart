import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_request_failure.freezed.dart';

@freezed
class HttpRequestFailure with _$HttpRequestFailure {
  const factory HttpRequestFailure.network() = _Network;
  const factory HttpRequestFailure.notFound() = _NotFound;
  const factory HttpRequestFailure.server() = _Server;
  const factory HttpRequestFailure.unknown() = _Unknown;
}
