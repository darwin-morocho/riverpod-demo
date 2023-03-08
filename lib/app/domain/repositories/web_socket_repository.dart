import '../models/crypto_update.dart';

abstract class WebSocketRepository {
  Future<bool> connect(List<String> ids);
  Stream<List<CryptoUpdate>> get onPriceChanged;
}
