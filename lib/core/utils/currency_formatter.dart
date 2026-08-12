import 'package:intl/intl.dart';

import '../../domain/entities/currency.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.decimalPattern('ar');

  static String format(
    double amount, {
    CurrencyCode currency = CurrencyCode.yer,
  }) {
    return '${formatNumberOnly(amount)} ${currency.symbol}';
  }

  static String formatNumberOnly(double amount) {
    return _formatter.format(amount);
  }

  static String formatSigned(
    double amount, {
    required bool isIncome,
    CurrencyCode? currency,
  }) {
    final sign = isIncome ? '+' : '-';
    final suffix = currency == null ? '' : ' ${currency.symbol}';
    return '$sign${_formatter.format(amount.abs())}$suffix';
  }

  static String formatCompact(
    double amount, {
    CurrencyCode? currency,
  }) {
    final value = amount.abs();
    final formatted = value >= 1000000
        ? '${(value / 1000000).toStringAsFixed(1)}M'
        : value >= 1000
            ? '${(value / 1000).toStringAsFixed(1)}K'
            : value.toStringAsFixed(0);
    final suffix = currency == null ? '' : ' ${currency.symbol}';
    return '${amount < 0 ? '-' : ''}$formatted$suffix';
  }
}
