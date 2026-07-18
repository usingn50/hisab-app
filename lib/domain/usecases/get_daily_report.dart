import '../entities/report.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetDailyReport {
  final TransactionRepository transactionRepository;

  GetDailyReport({required this.transactionRepository});

  Future<Report> call({
    required String userId,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final transactions = await transactionRepository.getByDateRange(
      userId: userId,
      start: startOfDay,
      end: endOfDay,
    );

    final revenue = transactions
        .where((t) => t.type == TransactionType.sale)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    return Report(
      id: '${userId}_${startOfDay.toIso8601String()}',
      userId: userId,
      period: ReportPeriod.day,
      startDate: startOfDay,
      endDate: endOfDay,
      revenue: revenue,
      expenses: expenses,
    );
  }
}
