import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<void> add(Customer customer);
  Future<void> update(Customer customer);
  Future<void> delete(String id);
  Future<Customer?> getById(String id);
  Future<List<Customer>> getAll(String userId);
  Future<List<Customer>> getWithDebt(String userId);
  Future<void> addDebt(String customerId, double amount);
  Future<void> recordPayment(String customerId, double amount);
}
