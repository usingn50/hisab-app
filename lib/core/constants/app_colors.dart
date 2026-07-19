import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // الألوان الأساسية — تطابق هوية الأيقونة الجديدة (ذهبي/أزرق)
  static const Color primary = Color(0xFF3B82F6);        // أزرق
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF93C5FD);

  // الذهبي للمميزات
  static const Color gold = Color(0xFFEAB308);
  static const Color goldLight = Color(0xFFFDE047);

  // خلفيات
  static const Color background = Color(0xFF0F172A);     // أزرق داكن جداً
  static const Color surface = Color(0xFF1E293B);        // بطاقات
  static const Color surfaceLight = Color(0xFF334155);   // عناصر ثانوية

  // نصوص
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF475569);

  // حالات — success يبقى أخضر عمداً (دلالة مالية عالمية: ربح/إيجابي)
  // ومنفصل تماماً عن primary حتى لو تغيّر لون العلامة التجارية مستقبلاً
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF86EFAC);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFEAB308);
  static const Color info = Color(0xFF06B6D4);

  // الحدود
  static const Color border = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFF334155);
}
