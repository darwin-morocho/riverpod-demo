import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_update.freezed.dart';

@freezed
class CryptoUpdate with _$CryptoUpdate {
  factory CryptoUpdate({
    required String id,
    @JsonKey(fromJson: double.parse) required double price,
  }) = _CryptoUpdate;
}
