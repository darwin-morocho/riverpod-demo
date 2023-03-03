import 'dart:async';

import 'package:riverpod/riverpod.dart';

import '../../../../domain/models/crypto.dart';
import '../../../../domain/repositories/web_socket_repository.dart';
import '../../../../repositories.dart';
import '../../../my_app.dart';

final homeProvider = StateNotifierProvider<HomeBloc, List<Crypto>>(
  (ref) => HomeBloc(
    ref.read(loadDataProvider).value!,
    webSocketRepository: ref.read(Repositories.webSocket),
  )..init(),
);

class HomeBloc extends StateNotifier<List<Crypto>> {
  HomeBloc(
    super.state, {
    required WebSocketRepository webSocketRepository,
  }) : _webSocketRepository = webSocketRepository;

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

        for (final item in updates) {
          final index = state.indexWhere(
            (element) => element.id == item.id,
          );
          if (index != -1) {
            cryptos[index] = cryptos[index].copyWith(
              priceUsd: item.price,
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
