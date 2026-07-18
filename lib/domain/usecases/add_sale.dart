import 'package:uuid/uuid.dart';
import '../entities/transaction.dart';
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

  AddSale({
    required this.transactionRepository,
    required this.productRepository,
    required this.customerRepository,
  });

  Future<Transaction> call({
    required String userId,
    required String productId,
    required int quantity,
    required double amount,
    required PaymentMethod payment,
    String? customerId,
    String? notes,
  }) async {
    // 1. إنشاء المعاملة
    final transaction = Transaction(
      id: const Uuid().v4(),
      userId: userId,
      productId: productId,
      customerId: customerId,
      type: TransactionType.sale,
      payment: payment,
      amount: amount,
      quantity: quantity,
      notes: notes,
      createdAt: DateTime.now(),
      synced: false,
    );

    await transactionRepository.add(transaction);

    // 2. خصم الكمية من المخزون تلقائياً
    await productRepository.decreaseStock(productId, quantity);

    // 3. إذا كان البيع آجلاً، أضف المبلغ لدين الزبون
    if (payment == PaymentMethod.credit && customerId != null) {
      await customerRepository.addDebt(customerId, amount);
    }

    return transaction;
  }
}
