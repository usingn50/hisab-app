enum CurrencyCode { yer, usd, sar }

extension CurrencyCodeX on CurrencyCode {
  String get value => switch (this) {
        CurrencyCode.yer => 'YER',
        CurrencyCode.usd => 'USD',
        CurrencyCode.sar => 'SAR',
      };

  String get label => switch (this) {
        CurrencyCode.yer => 'ريال يمني',
        CurrencyCode.usd => 'دولار أمريكي',
        CurrencyCode.sar => 'ريال سعودي',
      };

  String get symbol => switch (this) {
        CurrencyCode.yer => 'ر.ي',
        CurrencyCode.usd => r'$',
        CurrencyCode.sar => 'ر.س',
      };
}

CurrencyCode currencyCodeFromValue(String value) {
  return switch (value.toUpperCase()) {
    'USD' => CurrencyCode.usd,
    'SAR' => CurrencyCode.sar,
    _ => CurrencyCode.yer,
  };
}

class ExchangeRate {
  final String id;
  final String userId;
  final CurrencyCode fromCurrency;
  final CurrencyCode toCurrency;
  final double rate;
  final DateTime effectiveAt;
  final DateTime createdAt;

  const ExchangeRate({
    required this.id,
    required this.userId,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.effectiveAt,
    required this.createdAt,
  }) : assert(rate > 0);

  double convert(double amount) => amount * rate;
}
