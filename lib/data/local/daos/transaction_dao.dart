import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<int> insertTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  Future<bool> updateTransaction(TransactionsCompanion entry) {
    return update(transactions).replace(entry);
  }

  Future<int> deleteTransaction(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<Transaction?> getById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// جلب المعاملات ضمن مدى تاريخي — أساس التقارير اليومية/الأسبوعية/الشهرية
  Future<List<Transaction>> getByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) {
    return (select(transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// آخر العمليات لعرضها في لوحة التحكم
  Future<List<Transaction>> getRecent(String userId, {int limit = 10}) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// المعاملات التي لم تتم مزامنتها بعد مع السيرفر
  Future<List<Transaction>> getUnsynced(String userId) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId) & t.synced.equals(false)))
        .get();
  }

  Future<void> markSynced(List<String> ids) async {
    await (update(transactions)..where((t) => t.id.isIn(ids)))
        .write(const TransactionsCompanion(synced: Value(true)));
  }

  /// مجموع المبيعات النقدية ضمن فترة — يُستخدم في حساب الربح اليومي
  Stream<List<Transaction>> watchByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) {
    return (select(transactions)
          ..where((t) =>
              t.userId.equals(userId) &
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }
}
