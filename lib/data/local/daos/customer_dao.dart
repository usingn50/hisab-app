import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'customer_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomerDao extends DatabaseAccessor<AppDatabase>
    with _$CustomerDaoMixin {
  CustomerDao(super.db);

  Future<int> insertCustomer(CustomersCompanion entry) {
    return into(customers).insert(entry);
  }

  Future<bool> updateCustomer(CustomersCompanion entry) {
    return update(customers).replace(entry);
  }

  Future<int> deleteCustomer(String id) {
    return (delete(customers)..where((c) => c.id.equals(id))).go();
  }

  Future<Customer?> getById(String id) {
    return (select(customers)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Customer>> getAll(String userId) {
    return (select(customers)
          ..where((c) => c.userId.equals(userId))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// الزبائن الذين عليهم ديون — أساس شاشة "دفتر الديون"
  Future<List<Customer>> getWithDebt(String userId) {
    return (select(customers)
          ..where((c) => c.userId.equals(userId) & c.totalDebt.isBiggerThanValue(0))
          ..orderBy([(c) => OrderingTerm.desc(c.totalDebt)]))
        .get();
  }

  /// إضافة دين جديد عند بيع آجل
  Future<void> addDebt(String customerId, double amount) async {
    final customer = await getById(customerId);
    if (customer == null) return;
    await (update(customers)..where((c) => c.id.equals(customerId))).write(
      CustomersCompanion(totalDebt: Value(customer.totalDebt + amount)),
    );
  }

  /// تسجيل دفعة من الزبون — تنقص الدين وتحدّث تاريخ آخر دفعة
  Future<void> recordPayment(String customerId, double amount) async {
    final customer = await getById(customerId);
    if (customer == null) return;
    final newDebt =
        (customer.totalDebt - amount).clamp(0, double.infinity).toDouble();
    await (update(customers)..where((c) => c.id.equals(customerId))).write(
      CustomersCompanion(
        totalDebt: Value(newDebt),
        lastPaymentDate: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<Customer>> watchWithDebt(String userId) {
    return (select(customers)
          ..where((c) => c.userId.equals(userId) & c.totalDebt.isBiggerThanValue(0))
          ..orderBy([(c) => OrderingTerm.desc(c.totalDebt)]))
        .watch();
  }
}
