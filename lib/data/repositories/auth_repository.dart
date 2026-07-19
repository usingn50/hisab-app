import 'package:dio/dio.dart';
import '../remote/api_client.dart';
import '../../core/services/session_service.dart';

/// نتيجة إرسال OTP
sealed class SendOtpResult {
  const SendOtpResult();
}

class SendOtpSuccess extends SendOtpResult {
  const SendOtpSuccess();
}

class SendOtpFailure extends SendOtpResult {
  final String message;
  const SendOtpFailure(this.message);
}

/// نتيجة التحقق من OTP
sealed class VerifyOtpResult {
  const VerifyOtpResult();
}

class VerifyOtpSuccess extends VerifyOtpResult {
  /// معرّف المستخدم — حالياً رقم الهاتف، لاحقاً UUID من الـ Backend
  final String userId;
  const VerifyOtpSuccess(this.userId);
}

class VerifyOtpFailure extends VerifyOtpResult {
  final String message;
  const VerifyOtpFailure(this.message);
}

/// طبقة المصادقة — تتولى إرسال OTP والتحقق منه وحفظ الجلسة.
///
/// الوضع الحالي: [_backendEnabled] = false → محاكاة محلية آمنة.
/// لتفعيل الـ Backend الحقيقي: غيّر [_backendEnabled] إلى true بعد
/// نشر سيرفر Node.js وتحديث [ApiClient.baseUrl].
class AuthRepository {
  final ApiClient _api;

  /// رمز OTP الثابت للتطوير — يُقبل فقط عندما يكون _backendEnabled = false
  static const _devOtp = '123456';

  /// اضبطها على true عند ربط الـ Backend الفعلي
  static const _backendEnabled = false;

  AuthRepository(this._api);

  Future<SendOtpResult> sendOtp(String phone) async {
    if (!_backendEnabled) {
      // محاكاة: تأخير 600ms لمحاكاة الشبكة
      await Future.delayed(const Duration(milliseconds: 600));
      return const SendOtpSuccess();
    }

    try {
      await _api.sendOtp(phone);
      return const SendOtpSuccess();
    } on DioException catch (e) {
      return SendOtpFailure(_extractMessage(e, fallback: 'تعذر إرسال رمز التحقق'));
    } catch (_) {
      return const SendOtpFailure('خطأ غير متوقع، حاول مرة أخرى');
    }
  }

  Future<VerifyOtpResult> verifyOtp(String phone, String otp) async {
    if (!_backendEnabled) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (otp == _devOtp) {
        final userId = await SessionService.saveSession(phone);
        return VerifyOtpSuccess(userId);
      }
      return const VerifyOtpFailure('الرمز غير صحيح — استخدم 123456 في وضع التطوير');
    }

    try {
      final token = await _api.verifyOtp(phone, otp);
      // عند ربط Backend حقيقي: حفظ الـ JWT token + استخراج userId منه
      // حالياً: استخدام رقم الهاتف كـ userId مع حفظ الـ token للاستخدام لاحقاً
      final userId = await SessionService.saveSession(phone);
      _api.setAuthToken(token);
      return VerifyOtpSuccess(userId);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 400) {
        return const VerifyOtpFailure('رمز التحقق غير صحيح أو منتهي الصلاحية');
      }
      if (status == 429) {
        return const VerifyOtpFailure('محاولات كثيرة — انتظر دقيقة وحاول مجدداً');
      }
      return VerifyOtpFailure(_extractMessage(e, fallback: 'تعذر التحقق من الرمز'));
    } catch (_) {
      return const VerifyOtpFailure('خطأ غير متوقع، حاول مرة أخرى');
    }
  }

  static String _extractMessage(DioException e, {required String fallback}) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] is String) return data['message'];
    } catch (_) {}
    return fallback;
  }
}
