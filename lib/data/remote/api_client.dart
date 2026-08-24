import 'package:dio/dio.dart';

import '../local/database/app_database.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ??
                const String.fromEnvironment(
                  'HISAB_API_BASE_URL',
                  defaultValue: 'https://api.hisab-app.com/v1',
                ),
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 20),
          ),
        );

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<void> sendOtp(String phone) async {
    await _dio.post('/auth/send-otp', data: {'phone': phone});
  }

  Future<String> verifyOtp(String phone, String otp) async {
    final response = await _dio.post('/auth/verify-otp', data: {
      'phone': phone,
      'otp': otp,
    });
    return response.data['token'] as String;
  }

  Future<void> uploadTransactions(List<Transaction> transactions) async {
    await _dio.post('/sync/transactions', data: {
      'transactions': transactions
          .map(
            (transaction) => {
              'id': transaction.id,
              'user_id': transaction.userId,
              'customer_id': transaction.customerId,
              'product_id': transaction.productId,
              'type': transaction.type,
              'payment': transaction.payment,
              'amount': transaction.amount,
              'quantity': transaction.quantity,
              'notes': transaction.notes,
              'created_at': transaction.createdAt.toIso8601String(),
            },
          )
          .toList(),
    });
  }

  Future<SyncPushResponse> pushMutations({
    required String organizationId,
    required String deviceId,
    required List<SyncMutationRequest> mutations,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/organizations/$organizationId/sync/mutations',
      data: {
        'deviceId': deviceId,
        'mutations': mutations.map((mutation) => mutation.toJson()).toList(),
      },
    );
    return SyncPushResponse.fromJson(_jsonMap(response.data));
  }

  Future<SyncChangePage> pullChanges({
    required String organizationId,
    required String cursor,
    int limit = 200,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/organizations/$organizationId/sync/changes',
      queryParameters: {'cursor': cursor, 'limit': limit},
    );
    return SyncChangePage.fromJson(_jsonMap(response.data));
  }

  Future<SyncBootstrap> bootstrap({
    required String organizationId,
    required String deviceId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/organizations/$organizationId/sync/bootstrap',
      data: {'deviceId': deviceId},
    );
    return SyncBootstrap.fromJson(_jsonMap(response.data));
  }

  Future<Map<String, dynamic>> getCreditProfile(String userId) async {
    final response = await _dio.get('/credit/$userId');
    return _jsonMap(response.data);
  }

  Future<String> generateShareLink(String userId) async {
    final response = await _dio.post('/credit/$userId/share');
    return _jsonMap(response.data)['share_url'] as String;
  }
}

class SyncMutationRequest {
  final String mutationId;
  final DateTime clientCreatedAt;
  final String operation;
  final String entityId;
  final Map<String, dynamic> payload;

  const SyncMutationRequest({
    required this.mutationId,
    required this.clientCreatedAt,
    required this.operation,
    required this.entityId,
    required this.payload,
  });

  Map<String, dynamic> toJson() => {
        'mutationId': mutationId,
        'clientCreatedAt': clientCreatedAt.toUtc().toIso8601String(),
        'operation': operation,
        'entityId': entityId,
        'payload': payload,
      };
}

class SyncMutationResult {
  final String mutationId;
  final String status;
  final String entityType;
  final String entityId;
  final String? version;
  final String? errorCode;
  final String? errorMessage;

  const SyncMutationResult({
    required this.mutationId,
    required this.status,
    required this.entityType,
    required this.entityId,
    required this.version,
    required this.errorCode,
    required this.errorMessage,
  });

  factory SyncMutationResult.fromJson(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>?;
    return SyncMutationResult(
      mutationId: json['mutationId'] as String,
      status: json['status'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      version: json['version'] as String?,
      errorCode: error?['code'] as String?,
      errorMessage: error?['message'] as String?,
    );
  }
}

class SyncPushResponse {
  final List<SyncMutationResult> results;

  const SyncPushResponse(this.results);

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    final rows = (json['results'] as List<dynamic>? ?? const []);
    return SyncPushResponse(
      rows
          .map((row) => SyncMutationResult.fromJson(_jsonMap(row)))
          .toList(growable: false),
    );
  }
}

class SyncChange {
  final String sequence;
  final String entityType;
  final String entityId;
  final String operation;
  final String version;
  final Map<String, dynamic> payload;
  final DateTime changedAt;

  const SyncChange({
    required this.sequence,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.version,
    required this.payload,
    required this.changedAt,
  });

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
        sequence: json['sequence'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        operation: json['operation'] as String,
        version: json['version'] as String,
        payload: _jsonMap(json['payload']),
        changedAt: DateTime.parse(json['changedAt'] as String).toUtc(),
      );
}

class SyncChangePage {
  final List<SyncChange> changes;
  final String nextCursor;
  final bool hasMore;

  const SyncChangePage({
    required this.changes,
    required this.nextCursor,
    required this.hasMore,
  });

  factory SyncChangePage.fromJson(Map<String, dynamic> json) {
    final rows = (json['changes'] as List<dynamic>? ?? const []);
    return SyncChangePage(
      changes: rows
          .map((row) => SyncChange.fromJson(_jsonMap(row)))
          .toList(growable: false),
      nextCursor: json['nextCursor'] as String,
      hasMore: json['hasMore'] as bool,
    );
  }
}

class SyncBootstrap {
  final String snapshotId;
  final String highWatermarkCursor;
  final List<Map<String, dynamic>> branches;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> customers;

  const SyncBootstrap({
    required this.snapshotId,
    required this.highWatermarkCursor,
    required this.branches,
    required this.products,
    required this.customers,
  });

  factory SyncBootstrap.fromJson(Map<String, dynamic> json) => SyncBootstrap(
        snapshotId: json['snapshotId'] as String,
        highWatermarkCursor: json['highWatermarkCursor'] as String,
        branches: _jsonList(json['branches']),
        products: _jsonList(json['products']),
        customers: _jsonList(json['customers']),
      );
}

Map<String, dynamic> _jsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  throw FormatException('Expected JSON object, received $value');
}

List<Map<String, dynamic>> _jsonList(Object? value) {
  if (value is! List) return const [];
  return value.map(_jsonMap).toList(growable: false);
}
