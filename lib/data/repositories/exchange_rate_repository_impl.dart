import 'package:drift/drift.dart';

import '../../domain/entities/currency.dart' as entity;
import '../../domain/repositories/exchange_rate_repository.dart';
import '../local/daos/exchange_rate_dao.dart';
import '../local/database/app_database.dart' as database;

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateDao dao;

  ExchangeRateRepositoryImpl(this.dao);

  entity.ExchangeRate _toEntity(database.ExchangeRate row) {
    return entity.ExchangeRate(
      id: row.id,
      userId: row.userId,
      fromCurrency: entity.currencyCodeFromValue(row.fromCurrency),
      toCurrency: entity.currencyCodeFromValue(row.toCurrency),
      rate: row.rate,
      effectiveAt: row.effectiveAt,
      createdAt: row.createdAt,
    );
  }

  database.ExchangeRatesCompanion _toCompanion(entity.ExchangeRate rate) {
    return database.ExchangeRatesCompanion(
      id: Value(rate.id),
      userId: Value(rate.userId),
      fromCurrency: Value(rate.fromCurrency.value),
      toCurrency: Value(rate.toCurrency.value),
      rate: Value(rate.rate),
      effectiveAt: Value(rate.effectiveAt),
      createdAt: Value(rate.createdAt),
    );
  }

  @override
  Future<void> add(entity.ExchangeRate rate) async {
    await dao.insertRate(_toCompanion(rate));
  }

  @override
  Future<entity.ExchangeRate?> getLatest({
    required String userId,
    required entity.CurrencyCode fromCurrency,
    required entity.CurrencyCode toCurrency,
  }) async {
    final row = await dao.getLatest(
      userId: userId,
      fromCurrency: fromCurrency.value,
      toCurrency: toCurrency.value,
    );
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<entity.ExchangeRate>> getHistory({
    required String userId,
    required entity.CurrencyCode fromCurrency,
    required entity.CurrencyCode toCurrency,
  }) async {
    final rows = await dao.getHistory(
      userId: userId,
      fromCurrency: fromCurrency.value,
      toCurrency: toCurrency.value,
    );
    return rows.map(_toEntity).toList();
  }
}
