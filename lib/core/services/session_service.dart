import 'package:shared_preferences/shared_preferences.dart';

/// يدير جلسة تسجيل الدخول المحلية (بدون Backend حالياً).
///
/// نستخدم رقم الهاتف نفسه كـ userId مؤقتاً — مستقر وفريد لكل مستخدم،
/// ويسهل استبداله لاحقاً بمعرّف حقيقي من السيرفر عند ربط الـ Backend
/// دون تغيير أي كود بالشاشات (كلها تعتمد على [currentUserIdProvider]).
class SessionService {
  SessionService._();

  static const _keyUserId = 'user_id';
  static const _keyPhone = 'user_phone';

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhone);
  }

  /// يُستدعى بعد نجاح التحقق من رمز OTP لحفظ الجلسة محلياً.
  static Future<String> saveSession(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhone, phone);
    await prefs.setString(_keyUserId, phone);
    return phone;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyPhone);
  }
}
