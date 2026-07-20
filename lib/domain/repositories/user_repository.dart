import '../entities/app_user.dart';

abstract class UserRepository {
  /// يُنشئ مستخدماً جديداً إن لم يكن موجوداً بنفس رقم الهاتف، ويُعيد
  /// السجل الحالي أو الجديد. يُستدعى عند نجاح تسجيل الدخول (OTP).
  Future<AppUser> ensureExists(String phone);

  Future<AppUser?> getById(String id);

  Future<void> updateBusinessInfo({
    required String id,
    required String businessName,
    required String businessType,
    required String city,
  });
}
