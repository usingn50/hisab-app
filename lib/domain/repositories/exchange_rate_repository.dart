import '../entities/currency.dart';

abstract class ExchangeRateRepository {
  Future<void> add(ExchangeRate rate);

  Future<ExchangeRate?> getLatest({
    required String userId,
    required CurrencyCode fromCurrency,
    required CurrencyCode toCurrency,
  });

  Future<List<ExchangeRate>> getHistory({
    required String userId,
    required CurrencyCode fromCurrency,
    required CurrencyCode toCurrency,
  });
}
