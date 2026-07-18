import 'package:uuid/uuid.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class AddExpense {
  final TransactionRepository transactionRepository;

  AddExpense({required this.transactionRepository});

  Future<Transaction> call({
    required String userId,
    required double amount,
    String? notes,
  }) async {
    final transaction = Transaction(
      id: const Uuid().v4(),
      userId: userId,
      type: TransactionType.expense,
      payment: PaymentMethod.cash, // المصاريف تُسجَّل نقداً دائماً
      amount: amount,
      notes: notes,
      createdAt: DateTime.now(),
      synced: false,
    );

    await transactionRepository.add(transaction);
    return transaction;
  }
}
