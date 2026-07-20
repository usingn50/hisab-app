import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// يدير توليد share_token محلياً وفتح روابط المشاركة.
///
/// share_token = base64(userId + ":" + score + ":" + timestamp)
/// قابل للفك من أي طرف يعرف الصيغة — لا يحتاج سيرفر للقراءة.
/// عند ربط Backend: استبدل [_buildPublicUrl] برابط الـ API الفعلي.
class CreditShareService {
  CreditShareService._();

  static const _keyToken = 'credit_share_token';
  static const _keyTokenScore = 'credit_share_token_score';
  static const _keyTokenTs = 'credit_share_token_ts';

  /// أقصى عمر للـ token: 7 أيام — بعدها يُجدَّد تلقائياً
  static const _tokenTtlDays = 7;

  /// يولّد token جديد أو يُعيد الموجود إن لم ينته وقته
  static Future<String> getOrCreateToken({
    required String userId,
    required int score,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getString(_keyToken);
    final savedScore = prefs.getInt(_keyTokenScore);
    final savedTs = prefs.getInt(_keyTokenTs);

    if (existing != null && savedScore == score && savedTs != null) {
      final age = DateTime.now().millisecondsSinceEpoch - savedTs;
      if (age < _tokenTtlDays * 24 * 3600 * 1000) return existing;
    }

    // توليد token جديد
    final ts = DateTime.now().millisecondsSinceEpoch;
    final raw = '$userId:$score:$ts';
    final token = base64Url.encode(utf8.encode(raw));

    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyTokenScore, score);
    await prefs.setInt(_keyTokenTs, ts);

    return token;
  }

  /// يمسح الـ token المحفوظ — يُستدعى عند تسجيل الخروج
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyTokenScore);
    await prefs.remove(_keyTokenTs);
  }

  /// يبني رابط عرض الملف الائتماني
  /// حالياً: رابط GitHub Pages مؤقت — يُستبدل برابط الـ Backend عند الإطلاق
  static String buildPublicUrl(String token) {
    return 'https://usingn50.github.io/hisab-app/credit?t=$token';
  }

  /// يشارك الملف الائتماني عبر واتساب
  static Future<bool> shareViaWhatsApp({
    required String token,
    required int score,
    required String classify,
  }) async {
    final url = buildPublicUrl(token);
    final message = Uri.encodeComponent(
      'السلام عليكم،\n\nأشارككم ملفي الائتماني من تطبيق حساب:\n'
      '• الدرجة: $score/100 ($classify)\n'
      '• رابط التحقق: $url\n\n'
      'تطبيق حساب — نظام محاسبة ذكي للمشاريع الصغيرة 🇾🇪',
    );
    final waUrl = Uri.parse('https://wa.me/?text=$message');
    return launchUrl(waUrl, mode: LaunchMode.externalApplication);
  }

  /// ينسخ الرابط — يُستخدم مع Clipboard.setData من الشاشة
  static String buildShareText({
    required String token,
    required int score,
    required String classify,
  }) {
    final url = buildPublicUrl(token);
    return 'ملفي الائتماني من تطبيق حساب\n'
        'الدرجة: $score/100 ($classify)\n'
        '$url';
  }
}
