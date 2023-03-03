import '../../domain/inputs/interval.dart';
import '../../domain/models/crypto.dart';
import '../../domain/models/history_entry.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../../domain/typedefs.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  @override
  HttpFuture<List<HistoryEntry>> getHistory(
      String cryptoId, Interval interval) {
    // TODO: implement getHistory
    throw UnimplementedError();
  }

  @override
  HttpFuture<List<Crypto>> getPrices(List<String> ids) {
    // TODO: implement getPrices
    throw UnimplementedError();
  }
}
