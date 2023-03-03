import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'crypto.freezed.dart';
part 'crypto.g.dart';

@freezed
class Crypto with _$Crypto {
  factory Crypto({
    required String id,
    required String symbol,
    required String name,
    @JsonKey(fromJson: _doubleFromString) required double priceUsd,
    @JsonKey(fromJson: _doubleFromString) required double changePercent24Hr,
  }) = _Crypto;

  factory Crypto.fromJson(Json json) => _$CryptoFromJson(json);
}

double _doubleFromString(String text) => double.parse(text);
