import '../../domain/inputs/interval.dart';
import '../../domain/models/crypto.dart';
import '../../domain/models/history_entry.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../../domain/typedefs.dart';
import '../http/http.dart';
import '../utils/perform_http_request.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  ExchangeRepositoryImpl(this._http);
  final Http _http;

  @override
  HttpFuture<List<HistoryEntry>> getHistory(
    String cryptoId,
    Interval interval,
  ) {
    return performHttpRequest(
      _http.send(
        '/v2/assets/$cryptoId/history',
        queryParameters: {
          'interval': interval.name,
        },
        parser: (_, json) => buildList(
          json['data'],
          (e) => HistoryEntry.fromJson(e),
        ),
      ),
    );
  }

  @override
  HttpFuture<List<Crypto>> getPrices(List<String> ids) {
    return performHttpRequest(
      _http.send(
        '/v2/assets',
        queryParameters: {
          'ids': ids.join(','),
        },
        parser: (_, json) => buildList(
          json['data'],
          (e) => Crypto.fromJson(e),
        ),
      ),
    );
  }
}
