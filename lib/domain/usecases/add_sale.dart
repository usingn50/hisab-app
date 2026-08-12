import 'package:uuid/uuid.dart';
import '../entities/currency.dart';
import '../entities/transaction.dart';
import '../repositories/exchange_rate_repository.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/customer_repository.dart';

/// حالة استخدام إضافة عملية بيع
///
/// تتولى: إنشاء المعاملة، خصم الكمية من المخزون،
/// وتحديث دين الزبون إذا كان البيع بالآجل — كل هذا في عملية واحدة متكاملة.
class AddSale {
  final TransactionRepository transactionRepository;
  final ProductRepository productRepository;
  final CustomerRepository customerRepository;
  final ExchangeRateRepository exchangeRateRepository;

  AddSale({
    required this.transactionRepository,
    required this.productRepository,
    required this.customerRepository,
    required this.exchangeRateRepository,
  });

  Future<Transaction> call({
    required String userId,
    required String productId,
    required int quantity,
    required double amount,
    required PaymentMethod payment,
    CurrencyCode currency = CurrencyCode.yer,
    double exchangeRate = 1,
    String? customerId,
    String? notes,
  }) async {
    if (exchangeRate <= 0) {
      throw ArgumentError.value(exchangeRate, 'exchangeRate');
    }

    // 1. إنشاء المعاملة
    final transaction = Transaction(
      id: const Uuid().v4(),
      userId: userId,
      productId: productId,
      customerId: customerId,
      type: TransactionType.sale,
      payment: payment,
      amount: amount,
      currency: currency,
      exchangeRate: exchangeRate,
      baseAmount: amount * exchangeRate,
      quantity: quantity,
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

    // 2. خصم الكمية من المخزون تلقائياً
    await productRepository.decreaseStock(productId, quantity);

    // 3. إذا كان البيع آجلاً، أضف المبلغ لدين الزبون
    if (payment == PaymentMethod.credit && customerId != null) {
      await customerRepository.addDebt(
        customerId,
        transaction.amountInBaseCurrency,
      );
    }

    return transaction;
  }
}
