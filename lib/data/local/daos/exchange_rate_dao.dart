import 'package:drift/drift.dart';

import '../database/app_database.dart';

part 'exchange_rate_dao.g.dart';

@DriftAccessor(tables: [ExchangeRates])
class ExchangeRateDao extends DatabaseAccessor<AppDatabase>
    with _$ExchangeRateDaoMixin {
  ExchangeRateDao(super.db);

  Future<int> insertRate(ExchangeRatesCompanion entry) {
    return into(exchangeRates).insert(entry);
  }

  Future<ExchangeRate?> getLatest({
    required String userId,
    required String fromCurrency,
    required String toCurrency,
  }) {
    return (select(exchangeRates)
          ..where((rate) =>
              rate.userId.equals(userId) &
              rate.fromCurrency.equals(fromCurrency) &
              rate.toCurrency.equals(toCurrency))
          ..orderBy([(rate) => OrderingTerm.desc(rate.effectiveAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<ExchangeRate>> getHistory({
    required String userId,
    required String fromCurrency,
    required String toCurrency,
  }) {
    return (select(exchangeRates)
          ..where((rate) =>
              rate.userId.equals(userId) &
              rate.fromCurrency.equals(fromCurrency) &
              rate.toCurrency.equals(toCurrency))
          ..orderBy([(rate) => OrderingTerm.desc(rate.effectiveAt)]))
        .get();
  }
}
