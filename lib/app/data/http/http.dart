import 'dart:convert';

import 'package:http/http.dart';

enum HttpMethod {
  get,
  post,
  patch,
  put,
  delete,
}

class Http {
  Http(this._baseUrl, this._client);

  final String _baseUrl;
  final Client _client;

  Future<HttpResult<T>> send<T>(
    String path, {
    required T Function(int statusCode, dynamic data) parser,
    HttpMethod method = HttpMethod.get,
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    late Request request;
    late Response? response;
    late Uri url;
    try {
      if (path.startsWith('http')) {
        url = Uri.parse(path);
      } else {
        path = path.padLeft(1, '/');
        url = Uri.parse('$_baseUrl$path');
      }

      url = url.replace(
        queryParameters: queryParameters,
      );

      request = Request(method.name, url);

      if (method != HttpMethod.get) {
        headers = {
          ...headers,
          'Content-Type': 'application/json; charset=utf-8',
        };
        request.body = jsonEncode(body);
      }

      headers.addAll(headers);

      final streamedResponse = await _client.send(request);
      response = await Response.fromStream(streamedResponse);

      final statusCode = response.statusCode;
      final responseBody = _parseResponseBody(response.body);

      if (statusCode >= 200 && statusCode <= 399) {
        return HttpSuccess(
          statusCode,
          parser(
            statusCode,
            responseBody,
          ),
        );
      }

      return HttpFailure(
        statusCode,
        responseBody,
      );
    } catch (e) {
      return HttpFailure(
        response?.statusCode,
        e,
      );
    }
  }
}

abstract class HttpResult<T> {
  HttpResult(this.statusCode);
  final int? statusCode;
}

class HttpSuccess<T> extends HttpResult<T> {
  HttpSuccess(super.statusCode, this.data);
  final T data;
}

class HttpFailure<T> extends HttpResult<T> {
  HttpFailure(super.statusCode, this.data);
  final Object? data;
}

dynamic _parseResponseBody(String responseBody) {
  try {
    return jsonDecode(responseBody);
  } catch (_) {
    return responseBody;
  }
}
