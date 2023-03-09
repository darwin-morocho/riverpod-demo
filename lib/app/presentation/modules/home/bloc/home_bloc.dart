import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/crypto.dart';
import '../../../../domain/repositories/web_socket_repository.dart';
import '../../../my_app.dart';
import '../../../repositories.dart';

final homeProvider = StateNotifierProvider<HomeBloc, List<Crypto>>(
  (ref) => HomeBloc(
    ref.read(intialDataProvider).value!,
    ref.read(Repositories.ws),
  )..init(),
);

class HomeBloc extends StateNotifier<List<Crypto>> {
  HomeBloc(
    super.state,
    this._webSocketRepository,
  );

  final WebSocketRepository _webSocketRepository;
  StreamSubscription? _subscription;

  Future<void> init() async {
    final connected = await _webSocketRepository.connect(
      state.map((e) => e.id).toList(),
    );

    if (!connected) {
      return;
    }

    _subscription = _webSocketRepository.onPriceChanged.listen(
      (updates) {
        final cryptos = [...state];
        for (final update in updates) {
          final index = cryptos.indexWhere((e) => update.id == e.id);
          if (index != -1) {
            cryptos[index] = cryptos[index].copyWith(
              priceUsd: update.price,
            );
          }
        }
        state = cryptos;
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
