import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> add(Transaction transaction);
  Future<void> update(Transaction transaction);
  Future<void> delete(String id);
  Future<Transaction?> getById(String id);
  Future<List<Transaction>> getByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  });
  Future<List<Transaction>> getRecent(String userId, {int limit = 10});
  Future<List<Transaction>> getUnsynced(String userId);
  Future<void> markSynced(List<String> ids);
}
