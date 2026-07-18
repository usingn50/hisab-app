import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction.dart' as entity;
import '../../domain/repositories/transaction_repository.dart';
import '../local/daos/transaction_dao.dart';
import '../local/database/app_database.dart';

/// يحوّل بين Transaction (صف قاعدة البيانات) وTransaction (كيان الأعمال).
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDao dao;

  TransactionRepositoryImpl(this.dao);

  entity.Transaction _toEntity(Transaction row) {
    return entity.Transaction(
      id: row.id,
      userId: row.userId,
      customerId: row.customerId,
      productId: row.productId,
      type: row.type == 'sale'
          ? entity.TransactionType.sale
          : entity.TransactionType.expense,
      payment: row.payment == 'cash'
          ? entity.PaymentMethod.cash
          : entity.PaymentMethod.credit,
      amount: row.amount,
      quantity: row.quantity,
      notes: row.notes,
      createdAt: row.createdAt,
      synced: row.synced,
    );
  }

  TransactionsCompanion _toCompanion(entity.Transaction t) {
    return TransactionsCompanion(
      id: Value(t.id.isEmpty ? const Uuid().v4() : t.id),
      userId: Value(t.userId),
      customerId: Value(t.customerId),
      productId: Value(t.productId),
      type: Value(t.type == entity.TransactionType.sale ? 'sale' : 'expense'),
      payment:
          Value(t.payment == entity.PaymentMethod.cash ? 'cash' : 'credit'),
      amount: Value(t.amount),
      quantity: Value(t.quantity),
      notes: Value(t.notes),
      createdAt: Value(t.createdAt),
      synced: Value(t.synced),
    );
  }

  @override
  Future<void> add(entity.Transaction transaction) async {
    await dao.insertTransaction(_toCompanion(transaction));
  }

  @override
  Future<void> update(entity.Transaction transaction) async {
    await dao.updateTransaction(_toCompanion(transaction));
  }

  @override
  Future<void> delete(String id) async {
    await dao.deleteTransaction(id);
  }

  @override
  Future<entity.Transaction?> getById(String id) async {
    final row = await dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<entity.Transaction>> getByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    final rows =
        await dao.getByDateRange(userId: userId, start: start, end: end);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<entity.Transaction>> getRecent(String userId,
      {int limit = 10}) async {
    final rows = await dao.getRecent(userId, limit: limit);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<entity.Transaction>> getUnsynced(String userId) async {
    final rows = await dao.getUnsynced(userId);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> markSynced(List<String> ids) => dao.markSynced(ids);
}
