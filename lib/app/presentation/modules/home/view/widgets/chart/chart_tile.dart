import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/models/crypto.dart';
import '../chart.dart';
import '../crypto_info.dart';
import '../interval_picker.dart';
import 'providers.dart';

class ChartTile extends StatelessWidget {
  const ChartTile({
    super.key,
    required this.crypto,
  });
  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          CryptoInfo(crypto: crypto),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Consumer(
              builder: (_, ref, __) {
                return ref
                    .watch(
                      chartProvider.call(crypto.id),
                    )
                    .when(
                      data: (data) => CryptoLineChart(
                        data: data,
                      ),
                      error: (e, s) => Center(
                        child: Text(e.toString()),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (_, ref, __) {
                final provider = intervalProvider.call(crypto.id);
                final current = ref.watch(
                  provider,
                );
                return IntervalPicker(
                  onChanged: (interval) => ref
                      .read(
                        provider.notifier,
                      )
                      .update(
                        (_) => interval,
                      ),
                  current: current,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
