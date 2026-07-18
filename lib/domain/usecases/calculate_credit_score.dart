/// خوارزمية حساب درجة الائتمان (0-100)
///
/// هذه هي الميزة الفريدة في تطبيق حساب — لا يوجد لها مثيل في اليمن.
/// تعتمد على 4 عوامل رئيسية، كل عامل له وزن مختلف:
class CalculateCreditScore {
  /// يحسب الدرجة الائتمانية بناءً على بيانات المستخدم
  int call({
    required int monthsActive,
    required double avgMonthlyRevenue,
    required double profitConsistency, // 0-1: مدى ثبات الربح شهرياً
    required double debtRepaymentRate, // 0-1: نسبة سداد الزبائن لديونهم
  }) {
    // العامل 1: مدة النشاط (30% من الدرجة) — كلما طالت المدة زادت الثقة
    final activityScore = _scoreActivity(monthsActive) * 0.30;

    // العامل 2: متوسط الإيراد الشهري (25% من الدرجة)
    final revenueScore = _scoreRevenue(avgMonthlyRevenue) * 0.25;

    // العامل 3: ثبات الأرباح (25% من الدرجة) — عدم التذبذب الكبير
    final consistencyScore = (profitConsistency * 100) * 0.25;

    // العامل 4: انضباط تحصيل الديون (20% من الدرجة)
    final repaymentScore = (debtRepaymentRate * 100) * 0.20;

    final total =
        activityScore + revenueScore + consistencyScore + repaymentScore;

    return total.clamp(0, 100).round();
  }

  double _scoreActivity(int months) {
    // الحد الأقصى للنقاط يُمنح بعد 12 شهراً من النشاط المستمر
    if (months >= 12) return 100;
    return (months / 12) * 100;
  }

  double _scoreRevenue(double avgRevenue) {
    // مقياس نسبي: 500,000 ريال شهرياً يُعتبر نشاطاً قوياً (يُعدّل حسب بيانات السوق لاحقاً)
    const benchmark = 500000;
    final score = (avgRevenue / benchmark) * 100;
    return score.clamp(0, 100);
  }

  /// تصنيف الدرجة إلى فئة مفهومة للمستخدم
  static String classify(int score) {
    if (score >= 80) return 'ممتاز';
    if (score >= 60) return 'جيد جداً';
    if (score >= 40) return 'جيد';
    if (score >= 20) return 'متوسط';
    return 'ناشئ';
  }
}
