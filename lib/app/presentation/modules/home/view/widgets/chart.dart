import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/models/history_entry.dart';

class CryptoLineChart extends StatelessWidget {
  const CryptoLineChart({
    super.key,
    required this.data,
  });
  final List<HistoryEntry> data;

  @override
  Widget build(BuildContext context) {
    final minY = data.map((e) => e.priceUsd).reduce(math.min) * 0.8;
    final axisX = data.map((e) => e.time.millisecondsSinceEpoch);
    final minX = axisX.reduce(math.min);
    final maxX = axisX.reduce(math.max);

    final horizontalTitles = AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, __) {
          if (value == minY) {
            return const SizedBox();
          }
          return AutoSizeText(
            NumberFormat.compact().format(value),
            style: const TextStyle(fontSize: 10),
            maxLines: 1,
            minFontSize: 8,
          );
        },
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: LineChart(
        LineChartData(
          minY: minY,
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black,
              fitInsideHorizontally: true,
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map(
                    (e) => LineTooltipItem(
                      NumberFormat.currency().format(e.y),
                      const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(),
            rightTitles: horizontalTitles,
            leftTitles: horizontalTitles,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == minX || value == maxX) {
                    return const SizedBox();
                  }
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    value.toInt(),
                  );
                  return Text(
                    DateFormat('hh a').format(date),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              color: Colors.blue,
              isCurved: true,
              dotData: FlDotData(show: false),
              spots: data
                  .map(
                    (e) => FlSpot(
                      e.time.millisecondsSinceEpoch.toDouble(),
                      e.priceUsd,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
