import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/product.dart' as entity;
import '../../domain/repositories/product_repository.dart';
import '../local/daos/product_dao.dart';
import '../local/database/app_database.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDao dao;

  ProductRepositoryImpl(this.dao);

  entity.Product _toEntity(Product row) {
    return entity.Product(
      id: row.id,
      userId: row.userId,
      name: row.name,
      barcode: row.barcode,
      buyPrice: row.buyPrice,
      sellPrice: row.sellPrice,
      stockQty: row.stockQty,
      minStock: row.minStock,
      createdAt: row.createdAt,
    );
  }

  ProductsCompanion _toCompanion(entity.Product p) {
    return ProductsCompanion(
      id: Value(p.id.isEmpty ? const Uuid().v4() : p.id),
      userId: Value(p.userId),
      name: Value(p.name),
      barcode: Value(p.barcode),
      buyPrice: Value(p.buyPrice),
      sellPrice: Value(p.sellPrice),
      stockQty: Value(p.stockQty),
      minStock: Value(p.minStock),
      createdAt: Value(p.createdAt),
    );
  }

  @override
  Future<void> add(entity.Product product) async {
    await dao.insertProduct(_toCompanion(product));
  }

  @override
  Future<void> update(entity.Product product) async {
    await dao.updateProduct(_toCompanion(product));
  }

  @override
  Future<void> delete(String id) async {
    await dao.deleteProduct(id);
  }

  @override
  Future<entity.Product?> getById(String id) async {
    final row = await dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<entity.Product?> getByBarcode(String barcode) async {
    final row = await dao.getByBarcode(barcode);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<entity.Product>> getAll(String userId) async {
    final rows = await dao.getAll(userId);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<entity.Product>> getLowStock(String userId) async {
    final rows = await dao.getLowStock(userId);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> decreaseStock(String productId, int quantity) =>
      dao.decreaseStock(productId, quantity);

  @override
  Future<void> increaseStock(String productId, int quantity) =>
      dao.increaseStock(productId, quantity);
}
