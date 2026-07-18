import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/customer.dart' as entity;
import '../../domain/repositories/customer_repository.dart';
import '../local/daos/customer_dao.dart';
import '../local/database/app_database.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerDao dao;

  CustomerRepositoryImpl(this.dao);

  entity.Customer _toEntity(Customer row) {
    return entity.Customer(
      id: row.id,
      userId: row.userId,
      name: row.name,
      phone: row.phone,
      totalDebt: row.totalDebt,
      lastPaymentDate: row.lastPaymentDate,
      createdAt: row.createdAt,
    );
  }

  CustomersCompanion _toCompanion(entity.Customer c) {
    return CustomersCompanion(
      id: Value(c.id.isEmpty ? const Uuid().v4() : c.id),
      userId: Value(c.userId),
      name: Value(c.name),
      phone: Value(c.phone),
      totalDebt: Value(c.totalDebt),
      lastPaymentDate: Value(c.lastPaymentDate),
      createdAt: Value(c.createdAt),
    );
  }

  @override
  Future<void> add(entity.Customer customer) async {
    await dao.insertCustomer(_toCompanion(customer));
  }

  @override
  Future<void> update(entity.Customer customer) async {
    await dao.updateCustomer(_toCompanion(customer));
  }

  @override
  Future<void> delete(String id) async {
    await dao.deleteCustomer(id);
  }

  @override
  Future<entity.Customer?> getById(String id) async {
    final row = await dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<entity.Customer>> getAll(String userId) async {
    final rows = await dao.getAll(userId);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<entity.Customer>> getWithDebt(String userId) async {
    final rows = await dao.getWithDebt(userId);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> addDebt(String customerId, double amount) =>
      dao.addDebt(customerId, amount);

  @override
  Future<void> recordPayment(String customerId, double amount) =>
      dao.recordPayment(customerId, amount);
}
