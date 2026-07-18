import '../entities/product.dart';

abstract class ProductRepository {
  Future<void> add(Product product);
  Future<void> update(Product product);
  Future<void> delete(String id);
  Future<Product?> getById(String id);
  Future<Product?> getByBarcode(String barcode);
  Future<List<Product>> getAll(String userId);
  Future<List<Product>> getLowStock(String userId);
  Future<void> decreaseStock(String productId, int quantity);
  Future<void> increaseStock(String productId, int quantity);
}
