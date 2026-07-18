import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_sale.dart';
import '../../domain/usecases/add_expense.dart';

/// حالة شاشة إضافة معاملة
class TransactionFormState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const TransactionFormState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  TransactionFormState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return TransactionFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  final AddSale addSale;
  final AddExpense addExpense;

  TransactionFormNotifier({
    required this.addSale,
    required this.addExpense,
  }) : super(const TransactionFormState());

  Future<void> submitSale({
    required String userId,
    required String productId,
    required int quantity,
    required double amount,
    required PaymentMethod payment,
    String? customerId,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await addSale(
        userId: userId,
        productId: productId,
        quantity: quantity,
        amount: amount,
        payment: payment,
        customerId: customerId,
        notes: notes,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitExpense({
    required String userId,
    required double amount,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await addExpense(userId: userId, amount: amount, notes: notes);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() => state = const TransactionFormState();
}

// ملاحظة: dailyReportProvider يُفعَّل في هذا الملف بعد ربط
// getDailyReportProvider أعلاه (بعد إنشاء TransactionRepositoryImpl):
//
// final dailyReportProvider =
//     FutureProvider.family<Report, ({String userId, DateTime date})>(
//         (ref, params) async {
//   final getDailyReport = ref.watch(getDailyReportProvider);
//   return getDailyReport(userId: params.userId, date: params.date);
// });
