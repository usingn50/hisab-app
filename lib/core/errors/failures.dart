abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// خطأ في قاعدة البيانات المحلية
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'حدث خطأ في حفظ البيانات']);
}

/// خطأ في الاتصال بالسيرفر
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

/// خطأ في التحقق من البيانات
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// خطأ في المصادقة
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'فشل تسجيل الدخول']);
}

/// خطأ غير متوقع
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'حدث خطأ غير متوقع']);
}
