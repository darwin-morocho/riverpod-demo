import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/inputs/interval.dart';
import '../../../../../domain/models/history_entry.dart';
import '../../../../../repositories.dart';

final intervalProvider = StateProviderFamily<HistoryInterval, String>(
  (ref, arg) => HistoryInterval.d1,
);

final chartProvider = FutureProviderFamily<List<HistoryEntry>, String>(
  (ref, cryptoId) async {
    final interval = ref.watch(
      intervalProvider.call(cryptoId),
    );

    final result = await ref.watch(Repositories.exchange).getHistory(
          cryptoId,
          interval,
        );

    return result.when(
      left: (failure) => throw failure,
      right: (history) => history,
    );
  },
);
