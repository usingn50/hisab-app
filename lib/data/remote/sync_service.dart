import 'package:connectivity_plus/connectivity_plus.dart';
import '../local/daos/transaction_dao.dart';
import 'api_client.dart';

/// خدمة المزامنة — قلب مبدأ Offline-First
///
/// كل عملية تُحفظ محلياً فوراً بدون انتظار الإنترنت.
/// عند عودة الاتصال، هذه الخدمة ترفع كل العمليات غير المتزامنة للسيرفر.
class SyncService {
  final TransactionDao transactionDao;
  final ApiClient apiClient;
  final Connectivity connectivity;

  SyncService({
    required this.transactionDao,
    required this.apiClient,
    required this.connectivity,
  });

  /// يبدأ الاستماع لتغيرات الاتصال ويزامن تلقائياً عند توفر الإنترنت
  void startAutoSync(String userId) {
    connectivity.onConnectivityChanged.listen((result) async {
      final isConnected = result != ConnectivityResult.none;
      if (isConnected) {
        await syncNow(userId);
      }
    });
  }

  /// مزامنة فورية يدوية — يمكن استدعاؤها أيضاً بزر "تحديث"
  Future<SyncResult> syncNow(String userId) async {
    try {
      final unsynced = await transactionDao.getUnsynced(userId);

      if (unsynced.isEmpty) {
        return SyncResult(success: true, syncedCount: 0);
      }

      // رفع المعاملات للسيرفر دفعة واحدة لتقليل عدد الطلبات
      final ids = unsynced.map((t) => t.id).toList();
      await apiClient.uploadTransactions(unsynced);

      // تعليمها كمتزامنة محلياً بعد نجاح الرفع
      await transactionDao.markSynced(ids);

      return SyncResult(success: true, syncedCount: unsynced.length);
    } catch (e) {
      // فشل المزامنة لا يوقف التطبيق — البيانات تبقى محلية وتُحاول لاحقاً
      return SyncResult(success: false, syncedCount: 0, error: e.toString());
    }
  }
}

class SyncResult {
  final bool success;
  final int syncedCount;
  final String? error;

  SyncResult({required this.success, required this.syncedCount, this.error});
}
