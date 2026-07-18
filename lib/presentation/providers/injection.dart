import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/daos/transaction_dao.dart';
import '../../data/local/daos/product_dao.dart';
import '../../data/local/daos/customer_dao.dart';
import '../../data/remote/api_client.dart';
import '../../data/remote/sync_service.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/add_sale.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/get_daily_report.dart';
import '../../domain/usecases/calculate_credit_score.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/transaction.dart' as entity;
import 'transaction_provider.dart';

/// نقطة التجميع الوحيدة لكل تبعيات التطبيق.
/// أي شاشة تحتاج بيانات تستدعي الـ provider المناسب من هنا فقط.

// ===== قاعدة البيانات (Singleton لكل التطبيق) =====
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ===== DAOs =====
final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return TransactionDao(ref.watch(appDatabaseProvider));
});

final productDaoProvider = Provider<ProductDao>((ref) {
  return ProductDao(ref.watch(appDatabaseProvider));
});

final customerDaoProvider = Provider<CustomerDao>((ref) {
  return CustomerDao(ref.watch(appDatabaseProvider));
});

// ===== الشبكة =====
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    transactionDao: ref.watch(transactionDaoProvider),
    apiClient: ref.watch(apiClientProvider),
    connectivity: ref.watch(connectivityProvider),
  );
});

// ===== Repositories =====
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(ref.watch(transactionDaoProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productDaoProvider));
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(ref.watch(customerDaoProvider));
});

// ===== UseCases =====
final calculateCreditScoreProvider = Provider<CalculateCreditScore>((ref) {
  return CalculateCreditScore();
});

final addSaleProvider = Provider<AddSale>((ref) {
  return AddSale(
    transactionRepository: ref.watch(transactionRepositoryProvider),
    productRepository: ref.watch(productRepositoryProvider),
    customerRepository: ref.watch(customerRepositoryProvider),
  );
});

final addExpenseProvider = Provider<AddExpense>((ref) {
  return AddExpense(
      transactionRepository: ref.watch(transactionRepositoryProvider));
});

final getDailyReportProvider = Provider<GetDailyReport>((ref) {
  return GetDailyReport(
      transactionRepository: ref.watch(transactionRepositoryProvider));
});

// ===== نموذج إضافة معاملة (StateNotifier) =====
final transactionFormNotifierProvider =
    StateNotifierProvider<TransactionFormNotifier, TransactionFormState>((ref) {
  return TransactionFormNotifier(
    addSale: ref.watch(addSaleProvider),
    addExpense: ref.watch(addExpenseProvider),
  );
});

// ===== تقرير اليوم — يُستخدم مباشرة في لوحة التحكم =====
final dailyReportProvider =
    FutureProvider.family<Report, ({String userId, DateTime date})>(
        (ref, params) async {
  final getDailyReport = ref.watch(getDailyReportProvider);
  return getDailyReport(userId: params.userId, date: params.date);
});

/// Increments after saving a transaction so all dashboard data is refreshed.
final dashboardRefreshProvider = StateProvider<int>((ref) => 0);

class DashboardOverview {
  final Report report;
  final List<entity.Transaction> recentTransactions;
  final double totalDebt;

  const DashboardOverview({
    required this.report,
    required this.recentTransactions,
    required this.totalDebt,
  });
}

final dashboardOverviewProvider =
    FutureProvider.family<DashboardOverview, String>((ref, userId) async {
  ref.watch(dashboardRefreshProvider);

  final now = DateTime.now();
  final report = await ref.watch(getDailyReportProvider)(
    userId: userId,
    date: now,
  );
  final recentTransactions =
      await ref.watch(transactionRepositoryProvider).getRecent(userId);
  final customers = await ref.watch(customerRepositoryProvider).getAll(userId);

  return DashboardOverview(
    report: report,
    recentTransactions: recentTransactions,
    totalDebt: customers.fold<double>(
      0,
      (total, customer) => total + customer.totalDebt,
    ),
  );
});
