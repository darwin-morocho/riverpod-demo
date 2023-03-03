import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils.dart';

part 'crypto_update.freezed.dart';

@freezed
class CryptoUpdate with _$CryptoUpdate {
  factory CryptoUpdate({
    required String id,
    @JsonKey(fromJson: doubleFromString) required double price,
  }) = _CryptoUpdate;
}
