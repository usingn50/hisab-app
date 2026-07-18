class Product {
  final String id;
  final String userId;
  final String name;
  final String? barcode;
  final double buyPrice;
  final double sellPrice;
  final int stockQty;
  final int minStock;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.userId,
    required this.name,
    this.barcode,
    required this.buyPrice,
    required this.sellPrice,
    required this.stockQty,
    this.minStock = 5,
    required this.createdAt,
  });

  /// هامش الربح لكل وحدة
  double get profitMargin => sellPrice - buyPrice;

  /// نسبة الربح المئوية
  double get profitPercentage =>
      buyPrice == 0 ? 0 : (profitMargin / buyPrice) * 100;

  /// هل المخزون منخفض ويحتاج تنبيه؟
  bool get isLowStock => stockQty <= minStock;

  /// هل المخزون نفد تماماً؟
  bool get isOutOfStock => stockQty <= 0;

  Product copyWith({
    String? id,
    String? userId,
    String? name,
    String? barcode,
    double? buyPrice,
    double? sellPrice,
    int? stockQty,
    int? minStock,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      stockQty: stockQty ?? this.stockQty,
      minStock: minStock ?? this.minStock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
