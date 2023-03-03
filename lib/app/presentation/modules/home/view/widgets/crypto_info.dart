import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/models/crypto.dart';

class CryptoInfo extends StatelessWidget {
  const CryptoInfo({
    super.key,
    required this.crypto,
  });

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    final isNegative = crypto.changePercent24Hr.isNegative;
    final color = isNegative ? Colors.red : Colors.green;
    return ListTile(
      dense: true,
      title: Text(
        crypto.name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(crypto.symbol),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            NumberFormat.currency(symbol: 'USD ').format(
              crypto.priceUsd,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isNegative ? Icons.arrow_downward : Icons.arrow_upward,
                color: color,
                size: 15,
              ),
              Text(
                NumberFormat.compact().format(crypto.changePercent24Hr),
                style: TextStyle(
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
