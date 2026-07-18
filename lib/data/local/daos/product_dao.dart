import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase>
    with _$ProductDaoMixin {
  ProductDao(super.db);

  Future<int> insertProduct(ProductsCompanion entry) {
    return into(products).insert(entry);
  }

  Future<bool> updateProduct(ProductsCompanion entry) {
    return update(products).replace(entry);
  }

  Future<int> deleteProduct(String id) {
    return (delete(products)..where((p) => p.id.equals(id))).go();
  }

  Future<Product?> getById(String id) {
    return (select(products)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Product?> getByBarcode(String barcode) {
    return (select(products)..where((p) => p.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  Future<List<Product>> getAll(String userId) {
    return (select(products)
          ..where((p) => p.userId.equals(userId))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .get();
  }

  /// المنتجات التي وصلت لحد التنبيه — تُعرض في لوحة التحكم
  Future<List<Product>> getLowStock(String userId) async {
    final all = await getAll(userId);
    return all.where((p) => p.stockQty <= p.minStock).toList();
  }

  /// خصم الكمية بعد عملية بيع — عملية ذرية لتجنب تعارض البيانات
  Future<void> decreaseStock(String productId, int quantity) async {
    final product = await getById(productId);
    if (product == null) return;
    final newQty = (product.stockQty - quantity).clamp(0, 999999).toInt();
    await (update(products)..where((p) => p.id.equals(productId))).write(
      ProductsCompanion(stockQty: Value(newQty)),
    );
  }

  /// إضافة كمية عند شراء مخزون جديد
  Future<void> increaseStock(String productId, int quantity) async {
    final product = await getById(productId);
    if (product == null) return;
    final newQty = product.stockQty + quantity;
    await (update(products)..where((p) => p.id.equals(productId))).write(
      ProductsCompanion(stockQty: Value(newQty)),
    );
  }

  Stream<List<Product>> watchAll(String userId) {
    return (select(products)
          ..where((p) => p.userId.equals(userId))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .watch();
  }
}
