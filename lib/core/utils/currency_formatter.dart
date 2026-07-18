import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.decimalPattern('ar');

  /// يحول 15000 إلى "15,000 ريال"
  static String format(double amount) {
    return '${_formatter.format(amount)} ريال';
  }

  /// يحول 15000 إلى "15,000" بدون كلمة ريال (للاستخدام داخل بطاقات)
  static String formatNumberOnly(double amount) {
    return _formatter.format(amount);
  }

  /// يضيف + أو - حسب نوع المبلغ (دخل/مصروف)
  static String formatSigned(double amount, {required bool isIncome}) {
    final sign = isIncome ? '+' : '-';
    return '$sign${_formatter.format(amount.abs())}';
  }

  /// يحول الأرقام الكبيرة لصيغة مختصرة: 15000 -> 15K
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
