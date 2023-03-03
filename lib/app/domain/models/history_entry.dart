import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'history_entry.freezed.dart';
part 'history_entry.g.dart';

@freezed
class HistoryEntry with _$HistoryEntry {
  factory HistoryEntry({
    @JsonKey(fromJson: _doubleFromString) required double priceUsd,
    @JsonKey(fromJson: _dateFromUnix) required DateTime time,
  }) = _HistoryEntry;

  factory HistoryEntry.fromJson(Json json) => _$HistoryEntryFromJson(json);
}

double _doubleFromString(String text) => double.parse(text);
DateTime _dateFromUnix(int unix) => DateTime.fromMillisecondsSinceEpoch(unix);
