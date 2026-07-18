enum ReportPeriod { day, week, month }

class Report {
  final String id;
  final String userId;
  final ReportPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final double revenue;
  final double expenses;
  final List<ProductSales> topProducts;

  const Report({
    required this.id,
    required this.userId,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.revenue,
    required this.expenses,
    this.topProducts = const [],
  });

  double get profit => revenue - expenses;

  double get profitMargin => revenue == 0 ? 0 : (profit / revenue) * 100;

  bool get isProfitable => profit > 0;
}

class ProductSales {
  final String productId;
  final String productName;
  final int quantitySold;
  final double totalRevenue;

  const ProductSales({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.totalRevenue,
  });
}
