import 'package:drift/drift.dart';

import '../database/app_database.dart';

class SyncDao {
  final AppDatabase _database;

  SyncDao(this._database);

  Future<void> enqueue({
    required String mutationId,
    required String organizationId,
    required String entityType,
    required String operation,
    required String entityId,
    required String payloadJson,
    required DateTime createdAt,
  }) {
    return _database.into(_database.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            mutationId: mutationId,
            organizationId: organizationId,
            entityType: entityType,
            operation: operation,
            entityId: entityId,
            payloadJson: payloadJson,
            createdAt: createdAt,
          ),
        );
  }

  Future<List<SyncOutboxData>> pending(String organizationId, {int limit = 50}) {
    return (_database.select(_database.syncOutbox)
          ..where(
            (entry) =>
                entry.organizationId.equals(organizationId) &
                (entry.status.equals('pending') | entry.status.equals('retry_wait')),
          )
          ..orderBy([(entry) => OrderingTerm.asc(entry.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<void> markApplied(String mutationId) {
    return (_database.update(_database.syncOutbox)
          ..where((entry) => entry.mutationId.equals(mutationId)))
        .write(
      const SyncOutboxCompanion(
        status: Value('accepted'),
        lastError: Value(null),
      ),
    );
  }

  Future<void> markRetry(String mutationId, String message, DateTime nextAttemptAt) async {
    final entry = await (_database.select(_database.syncOutbox)
          ..where((row) => row.mutationId.equals(mutationId)))
        .getSingleOrNull();
    if (entry == null) return;

    await (_database.update(_database.syncOutbox)
          ..where((row) => row.mutationId.equals(mutationId)))
        .write(
      SyncOutboxCompanion(
        status: const Value('retry_wait'),
        attemptCount: Value(entry.attemptCount + 1),
        nextAttemptAt: Value(nextAttemptAt),
        lastError: Value(message),
      ),
    );
  }

  Future<void> markRejected(String mutationId, String message) {
    return (_database.update(_database.syncOutbox)
          ..where((entry) => entry.mutationId.equals(mutationId)))
        .write(
      SyncOutboxCompanion(
        status: const Value('rejected'),
        lastError: Value(message),
      ),
    );
  }

  Future<void> markConflict({
    required SyncOutboxData entry,
    required String reason,
    String? serverPayloadJson,
  }) async {
    await _database.transaction(() async {
      await (_database.update(_database.syncOutbox)
            ..where((row) => row.mutationId.equals(entry.mutationId)))
          .write(const SyncOutboxCompanion(status: Value('conflict')));
      await _database.into(_database.syncConflicts).insertOnConflictUpdate(
            SyncConflictsCompanion.insert(
              mutationId: entry.mutationId,
              entityId: entry.entityId,
              localPayloadJson: entry.payloadJson,
              serverPayloadJson: Value(serverPayloadJson),
              reason: reason,
              createdAt: DateTime.now(),
            ),
          );
    });
  }

  Future<SyncScope?> scope(String organizationId) {
    return (_database.select(_database.syncScopes)
          ..where((entry) => entry.organizationId.equals(organizationId)))
        .getSingleOrNull();
  }

  Future<void> saveCursor({
    required String organizationId,
    required String deviceId,
    required String cursor,
  }) {
    return _database.into(_database.syncScopes).insertOnConflictUpdate(
          SyncScopesCompanion.insert(
            organizationId: organizationId,
            deviceId: deviceId,
            lastPullCursor: Value(cursor),
            updatedAt: DateTime.now(),
            lastSuccessAt: Value(DateTime.now()),
          ),
        );
  }
}
