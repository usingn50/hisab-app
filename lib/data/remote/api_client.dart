import 'package:dio/dio.dart';
import '../local/database/app_database.dart';

/// عميل الاتصال بالـ API — يتعامل مع سيرفر Node.js/Express
class ApiClient {
  final Dio _dio;

  ApiClient({String baseUrl = 'https://api.hisab-app.com/v1'})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // ===== المصادقة =====

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

  // ===== المزامنة =====

  Future<void> uploadTransactions(List<Transaction> transactions) async {
    await _dio.post('/sync/transactions', data: {
      'transactions': transactions.map((t) => {
            'id': t.id,
            'user_id': t.userId,
            'customer_id': t.customerId,
            'product_id': t.productId,
            'type': t.type,
            'payment': t.payment,
            'amount': t.amount,
            'quantity': t.quantity,
            'notes': t.notes,
            'created_at': t.createdAt.toIso8601String(),
          }).toList(),
    });
  }

  // ===== السجل الائتماني =====

  Future<Map<String, dynamic>> getCreditProfile(String userId) async {
    final response = await _dio.get('/credit/$userId');
    return response.data as Map<String, dynamic>;
  }

  Future<String> generateShareLink(String userId) async {
    final response = await _dio.post('/credit/$userId/share');
    return response.data['share_url'] as String;
  }
}
