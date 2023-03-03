import 'package:flutter/material.dart';

import '../../../../../domain/inputs/interval.dart';

class IntervalPicker extends StatelessWidget {
  const IntervalPicker({
    super.key,
    required this.onChanged,
    required this.current,
  });
  final HistoryInterval current;
  final void Function(HistoryInterval interval) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: HistoryInterval.values
          .map(
            (e) => InkWell(
              onTap: () => onChanged(e),
              child: Chip(
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                backgroundColor:
                    current == e ? Colors.lightBlue : Colors.black12,
                label: Text(
                  e.name,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
