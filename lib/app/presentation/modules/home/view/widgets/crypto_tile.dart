import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/models/crypto.dart';
import '../providers/chart_providers.dart';
import 'crypto_chart.dart';
import 'crypto_info.dart';
import 'interval_picker.dart';

class CryptoTile extends StatelessWidget {
  const CryptoTile({
    super.key,
    required this.crypto,
  });
  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          CryptoInfo(crypto: crypto),
          CryptoHistoryChart(cryptoId: crypto.id),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer(
              builder: (_, ref, __) {
                final interval = ref.watch(
                  intervalProvider.call(crypto.id),
                );
                return IntervalPicker(
                  onChanged: (e) => ref
                      .read(
                        intervalProvider.call(crypto.id).notifier,
                      )
                      .update(
                        (_) => e,
                      ),
                  current: interval,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
