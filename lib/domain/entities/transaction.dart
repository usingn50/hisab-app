enum TransactionType { sale, expense }
enum PaymentMethod { cash, credit }

class Transaction {
  final String id;
  final String userId;
  final String? customerId;
  final String? productId;
  final TransactionType type;
  final PaymentMethod payment;
  final double amount;
  final int quantity;
  final String? notes;
  final DateTime createdAt;
  final bool synced;

  const Transaction({
    required this.id,
    required this.userId,
    this.customerId,
    this.productId,
    required this.type,
    required this.payment,
    required this.amount,
    this.quantity = 1,
    this.notes,
    required this.createdAt,
    this.synced = false,
  });

  bool get isSale => type == TransactionType.sale;
  bool get isExpense => type == TransactionType.expense;
  bool get isCredit => payment == PaymentMethod.credit;

  Transaction copyWith({
    String? id,
    String? userId,
    String? customerId,
    String? productId,
    TransactionType? type,
    PaymentMethod? payment,
    double? amount,
    int? quantity,
    String? notes,
    DateTime? createdAt,
    bool? synced,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      payment: payment ?? this.payment,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }
}
