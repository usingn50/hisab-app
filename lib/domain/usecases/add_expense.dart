import 'package:uuid/uuid.dart';
import '../entities/currency.dart';
import '../entities/transaction.dart';
import '../repositories/exchange_rate_repository.dart';
import '../repositories/transaction_repository.dart';

class AddExpense {
  final TransactionRepository transactionRepository;
  final ExchangeRateRepository exchangeRateRepository;

  AddExpense({
    required this.transactionRepository,
    required this.exchangeRateRepository,
  });

  Future<Transaction> call({
    required String userId,
    required double amount,
    CurrencyCode currency = CurrencyCode.yer,
    double exchangeRate = 1,
    String? notes,
  }) async {
    if (exchangeRate <= 0) {
      throw ArgumentError.value(exchangeRate, 'exchangeRate');
    }

    final transaction = Transaction(
      id: const Uuid().v4(),
      userId: userId,
      type: TransactionType.expense,
      payment: PaymentMethod.cash, // المصاريف تُسجَّل نقداً دائماً
      amount: amount,
      currency: currency,
      exchangeRate: exchangeRate,
      baseAmount: amount * exchangeRate,
      notes: notes,
      createdAt: DateTime.now(),
      synced: false,
    );

    await transactionRepository.add(transaction);
    if (currency != CurrencyCode.yer) {
      await exchangeRateRepository.add(
        ExchangeRate(
          id: const Uuid().v4(),
          userId: userId,
          fromCurrency: currency,
          toCurrency: CurrencyCode.yer,
          rate: exchangeRate,
          effectiveAt: transaction.createdAt,
          createdAt: transaction.createdAt,
        ),
      );
    }
    return transaction;
  }
}
