import 'currency.dart';

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
  final CurrencyCode currency;
  final double exchangeRate;
  final double? baseAmount;
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
    this.currency = CurrencyCode.yer,
    this.exchangeRate = 1,
    this.baseAmount,
    this.quantity = 1,
    this.notes,
    required this.createdAt,
    this.synced = false,
  });

  bool get isSale => type == TransactionType.sale;
  bool get isExpense => type == TransactionType.expense;
  bool get isCredit => payment == PaymentMethod.credit;
  double get amountInBaseCurrency => baseAmount ?? (amount * exchangeRate);

  Transaction copyWith({
    String? id,
    String? userId,
    String? customerId,
    String? productId,
    TransactionType? type,
    PaymentMethod? payment,
    double? amount,
    CurrencyCode? currency,
    double? exchangeRate,
    double? baseAmount,
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
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      baseAmount: baseAmount ?? this.baseAmount,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }
}
