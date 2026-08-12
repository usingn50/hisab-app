import 'package:flutter_test/flutter_test.dart';
import 'package:hisab/domain/entities/currency.dart';
import 'package:hisab/domain/entities/transaction.dart';

void main() {
  test('يحفظ التحويل التاريخي في القيمة الأساسية للمعاملة', () {
    final transaction = Transaction(
      id: 'sale-1',
      userId: 'user-1',
      type: TransactionType.sale,
      payment: PaymentMethod.cash,
      amount: 10,
      currency: CurrencyCode.usd,
      exchangeRate: 530,
      baseAmount: 5300,
      createdAt: DateTime(2026, 8, 12),
    );

    expect(transaction.amountInBaseCurrency, 5300);
  });

  test('يحافظ على سجلات الريال القديمة عند غياب القيمة الأساسية', () {
    final transaction = Transaction(
      id: 'sale-2',
      userId: 'user-1',
      type: TransactionType.sale,
      payment: PaymentMethod.cash,
      amount: 25000,
      createdAt: DateTime(2026, 8, 12),
    );

    expect(transaction.currency, CurrencyCode.yer);
    expect(transaction.amountInBaseCurrency, 25000);
  });

  test('يتعرف على رموز العملات المدعومة', () {
    expect(currencyCodeFromValue('USD'), CurrencyCode.usd);
    expect(currencyCodeFromValue('sar'), CurrencyCode.sar);
    expect(currencyCodeFromValue('unknown'), CurrencyCode.yer);
  });
}
