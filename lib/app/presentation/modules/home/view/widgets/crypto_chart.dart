import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chart_providers.dart';
import 'chart.dart';

class CryptoHistoryChart extends ConsumerWidget {
  const CryptoHistoryChart({
    super.key,
    required this.cryptoId,
  });
  final String cryptoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ref
          .watch(
            chartProvider.call(cryptoId),
          )
          .when(
            data: (history) => Column(
              children: [
                Expanded(
                  child: CryptoLineChart(data: history),
                ),
              ],
            ),
            error: (e, __) => Center(
              child: Text(
                e.toString(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
