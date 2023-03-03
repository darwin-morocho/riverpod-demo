import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'data/http/http.dart';
import 'data/repositories_impl/exchange_repository_impl.dart';
import 'data/repositories_impl/web_socket_repository_impl.dart';
import 'domain/repositories/exchange_repository.dart';
import 'domain/repositories/web_socket_repository.dart';

class Repositories {
  Repositories._();

  @visibleForTesting
  static final http = Provider<Http>(
    (_) => Http(
      'https://api.coincap.io',
      Client(),
    ),
  );

  static final exchange = Provider<ExchangeRepository>(
    (ref) => ExchangeRepositoryImpl(
      ref.read(http),
    ),
  );

  static final webSocket = Provider<WebSocketRepository>(
    (ref) => WebSocketReposiotryImpl(
      (ids) => WebSocketChannel.connect(
        Uri.parse(
          'wss://ws.coincap.io/prices?assets=${ids.join(',')}',
        ),
      ),
      const Duration(seconds: 5),
    ),
  );
}
