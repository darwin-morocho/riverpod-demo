import '../inputs/interval.dart';
import '../models/crypto.dart';
import '../models/history_entry.dart';
import '../typedefs.dart';

abstract class ExchangeRepository {
  HttpFuture<List<Crypto>> getPrices(List<String> ids);
  HttpFuture<List<HistoryEntry>> getHistory(
      String cryptoId, HistoryInterval interval);
}
