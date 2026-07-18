class Customer {
  final String id;
  final String userId;
  final String name;
  final String? phone;
  final double totalDebt;
  final DateTime? lastPaymentDate;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.userId,
    required this.name,
    this.phone,
    this.totalDebt = 0,
    this.lastPaymentDate,
    required this.createdAt,
  });

  bool get hasDebt => totalDebt > 0;

  /// عدد الأيام منذ آخر دفعة — مفيد لتحديد من يحتاج تذكيراً
  int? get daysSinceLastPayment {
    if (lastPaymentDate == null) return null;
    return DateTime.now().difference(lastPaymentDate!).inDays;
  }

  /// هل الزبون متأخر عن السداد أكثر من 30 يوماً؟
  bool get isOverdue {
    final days = daysSinceLastPayment;
    return hasDebt && days != null && days > 30;
  }

  Customer copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    double? totalDebt,
    DateTime? lastPaymentDate,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalDebt: totalDebt ?? this.totalDebt,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
