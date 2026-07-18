class Validators {
  Validators._();

  /// رقم الهاتف اليمني: يبدأ بـ 7 ويتكون من 9 أرقام
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^7[0-9]{8}$').hasMatch(cleaned)) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  /// المبلغ المالي: يجب أن يكون رقماً موجباً
  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال المبلغ';
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 'الرجاء إدخال رقم صحيح';
    }
    if (parsed <= 0) {
      return 'المبلغ يجب أن يكون أكبر من صفر';
    }
    return null;
  }

  /// حقل نصي مطلوب (اسم منتج، اسم زبون، إلخ)
  static String? required(String? value, {String fieldName = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  /// رمز OTP: 6 أرقام
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رمز التحقق';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'رمز التحقق يجب أن يكون 6 أرقام';
    }
    return null;
  }

  /// كمية المخزون: رقم صحيح غير سالب
  static String? quantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الكمية';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 0) {
      return 'الكمية غير صحيحة';
    }
    return null;
  }
}
