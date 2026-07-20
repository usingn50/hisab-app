/// يمثّل صاحب المشروع المسجّل في التطبيق.
///
/// ملاحظة معمارية: [id] هو رقم الهاتف حالياً (لا يوجد UUID صادر من Backend
/// بعد) — راجع .ai/STATE.md قبل تغيير هذا الافتراض.
class AppUser {
  final String id;
  final String phone;
  final String businessName;
  final String businessType;
  final String city;
  final String plan;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.phone,
    required this.businessName,
    required this.businessType,
    required this.city,
    this.plan = 'free',
    required this.createdAt,
  });

  bool get isPro => plan != 'free';
}
