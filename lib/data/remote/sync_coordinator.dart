import 'dart:convert';

import 'package:dio/dio.dart';

import '../local/daos/sync_dao.dart';
import 'api_client.dart';

typedef SyncChangeApplier = Future<void> Function(List<SyncChange> changes);

class SyncCoordinator {
  final ApiClient _apiClient;
  final SyncDao _syncDao;

  SyncCoordinator({
    required ApiClient apiClient,
    required SyncDao syncDao,
  })  : _apiClient = apiClient,
        _syncDao = syncDao;

  Future<SyncRunResult> sync({
    required String organizationId,
    required String deviceId,
    required SyncChangeApplier applyChanges,
  }) async {
    try {
      final sent = await _pushOutbox(
        organizationId: organizationId,
        deviceId: deviceId,
      );
      final received = await _pullChanges(
        organizationId: organizationId,
        deviceId: deviceId,
        applyChanges: applyChanges,
      );
      return SyncRunResult.success(sent: sent, received: received);
    } on DioException catch (error) {
      return SyncRunResult.failure(_networkMessage(error));
    } catch (error) {
      return SyncRunResult.failure(error.toString());
    }
  }

  Future<int> _pushOutbox({
    required String organizationId,
    required String deviceId,
  }) async {
    final pending = await _syncDao.pending(organizationId);
    if (pending.isEmpty) return 0;

    final request = pending
        .map(
          (entry) => SyncMutationRequest(
            mutationId: entry.mutationId,
            clientCreatedAt: entry.createdAt,
            operation: entry.operation,
            entityId: entry.entityId,
            payload: _decodePayload(entry.payloadJson),
          ),
        )
        .toList(growable: false);

    final response = await _apiClient.pushMutations(
      organizationId: organizationId,
      deviceId: deviceId,
      mutations: request,
    );
    final outboxById = {for (final entry in pending) entry.mutationId: entry};
    var accepted = 0;

    for (final result in response.results) {
      final entry = outboxById[result.mutationId];
      if (entry == null) continue;

      switch (result.status) {
        case 'applied':
        case 'duplicate':
          await _syncDao.markApplied(result.mutationId);
          accepted++;
          break;
        case 'conflict':
          await _syncDao.markConflict(
            entry: entry,
            reason: result.errorMessage ?? 'حدث تعارض يحتاج مراجعة.',
          );
          break;
        case 'rejected':
          await _syncDao.markRejected(
            result.mutationId,
            result.errorMessage ?? 'رفض الخادم الأمر.',
          );
          break;
        default:
          await _syncDao.markRetry(
            result.mutationId,
            result.errorMessage ?? 'تعذر تأكيد نتيجة الأمر.',
            _nextAttempt(entry.attemptCount),
          );
          break;
      }
    }

    return accepted;
  }

  Future<int> _pullChanges({
    required String organizationId,
    required String deviceId,
    required SyncChangeApplier applyChanges,
  }) async {
    var scope = await _syncDao.scope(organizationId);
    var cursor = scope?.lastPullCursor ?? '0';
    var received = 0;
    var hasMore = true;

    while (hasMore) {
      final page = await _apiClient.pullChanges(
        organizationId: organizationId,
        cursor: cursor,
      );
      if (page.changes.isNotEmpty) {
        await applyChanges(page.changes);
        received += page.changes.length;
      }
      cursor = page.nextCursor;
      hasMore = page.hasMore;

      if (!hasMore || page.changes.isEmpty) break;
    }

    if (scope != null || cursor != '0') {
      await _syncDao.saveCursor(
        organizationId: organizationId,
        deviceId: scope?.deviceId ?? deviceId,
        cursor: cursor,
      );
    }
    return received;
  }

  Map<String, dynamic> _decodePayload(String payloadJson) {
    final decoded = jsonDecode(payloadJson);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return decoded.cast<String, dynamic>();
    throw const FormatException('حمولة Outbox ليست كائن JSON.');
  }

  DateTime _nextAttempt(int attemptCount) {
    final seconds = 1 << attemptCount.clamp(0, 8);
    return DateTime.now().add(Duration(seconds: seconds));
  }

  String _networkMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final payload = data['error'];
      if (payload is Map && payload['message'] is String) {
        return payload['message'] as String;
      }
    }
    return 'تعذر الاتصال بالخادم.';
  }
}

class SyncRunResult {
  final bool success;
  final int sent;
  final int received;
  final String? error;

  const SyncRunResult._({
    required this.success,
    required this.sent,
    required this.received,
    required this.error,
  });

  factory SyncRunResult.success({required int sent, required int received}) {
    return SyncRunResult._(
      success: true,
      sent: sent,
      received: received,
      error: null,
    );
  }

  factory SyncRunResult.failure(String error) {
    return SyncRunResult._(
      success: false,
      sent: 0,
      received: 0,
      error: error,
    );
  }
}
