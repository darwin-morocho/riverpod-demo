import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/models/crypto_update.dart';
import '../../domain/repositories/web_socket_repository.dart';

class WebSocketReposiotryImpl implements WebSocketRepository {
  WebSocketReposiotryImpl(this.builder, this._reconnectDuration);

  final WebSocketChannel Function(List<String>) builder;
  final Duration _reconnectDuration;

  WebSocketChannel? _channel;
  StreamController<List<CryptoUpdate>>? _pricesController;
  StreamSubscription? _subscription;

  Timer? _timer;

  @override
  Future<bool> connect(List<String> ids) async {
    try {
      _channel = builder(ids);
      await _channel!.ready;
      _subscription = _channel!.stream.listen(
        (event) {
          final map = Map<String, String>.from(
            jsonDecode(event),
          );

          final updates = map.entries.map(
            (e) => CryptoUpdate(
              id: e.key,
              price: double.parse(e.value),
            ),
          );

          if (_pricesController?.hasListener ?? false) {
            _pricesController!.add(
              updates.toList(),
            );
          }
        },
        onDone: () {
          _reconnect(ids);
        },
      );

      return true;
    } catch (_) {
      _reconnect(ids);
      return false;
    }
  }

  void _reconnect(List<String> ids) {
    if (_subscription != null) {
      _timer?.cancel();
      _timer = Timer(
        _reconnectDuration,
        () {
          connect(ids);
        },
      );
    }
  }

  @override
  Stream<List<CryptoUpdate>> get onPriceChanged {
    _pricesController ??= StreamController.broadcast();
    return _pricesController!.stream;
  }
}
