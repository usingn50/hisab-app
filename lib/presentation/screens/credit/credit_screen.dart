import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/usecases/calculate_credit_score.dart';
import '../../providers/injection.dart';

const _currentUserId = 'local-user';

/// بيانات مدخلة لحساب الدرجة الائتمانية — تُجمع من سجل المعاملات الفعلي.
/// حالياً نحسبها من آخر 90 يوماً من المعاملات كنقطة بداية واقعية.
final _creditInputsProvider = FutureProvider.autoDispose<_CreditInputs>((ref) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  final start = now.subtract(const Duration(days: 90));

  final transactions = await transactionRepo.getByDateRange(
    userId: _currentUserId,
    start: start,
    end: now,
  );

  if (transactions.isEmpty) {
    return const _CreditInputs(
      monthsActive: 0,
      avgMonthlyRevenue: 0,
      profitConsistency: 0,
      debtRepaymentRate: 0,
      firstTransactionDate: null,
    );
  }

  final sorted = [...transactions]
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  final firstDate = sorted.first.createdAt;
  final monthsActive =
      ((now.difference(firstDate).inDays) / 30).ceil().clamp(0, 999);

  final sales = transactions.where((t) => t.isSale);
  final totalRevenue = sales.fold<double>(0, (sum, t) => sum + t.amount);
  final avgMonthlyRevenue =
      monthsActive == 0 ? totalRevenue : totalRevenue / monthsActive;

  // قياس مبسّط لثبات الأرباح وانضباط السداد — سيُستبدل بحساب أدق
  // عندما تتراكم بيانات كافية عبر أشهر متعددة فعلية.
  const profitConsistency = 0.7;
  const debtRepaymentRate = 0.8;

  return _CreditInputs(
    monthsActive: monthsActive,
    avgMonthlyRevenue: avgMonthlyRevenue,
    profitConsistency: profitConsistency,
    debtRepaymentRate: debtRepaymentRate,
    firstTransactionDate: firstDate,
  );
});

class _CreditInputs {
  final int monthsActive;
  final double avgMonthlyRevenue;
  final double profitConsistency;
  final double debtRepaymentRate;
  final DateTime? firstTransactionDate;

  const _CreditInputs({
    required this.monthsActive,
    required this.avgMonthlyRevenue,
    required this.profitConsistency,
    required this.debtRepaymentRate,
    required this.firstTransactionDate,
  });
}

/// شاشة السجل الائتماني — الميزة الفريدة في تطبيق حساب.
/// تبني تاريخاً مالياً موثقاً يمكن مشاركته مع الموردين أو الممولين.
class CreditScreen extends ConsumerWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputsAsync = ref.watch(_creditInputsProvider);
    final calculator = ref.watch(calculateCreditScoreProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.creditScore)),
      body: SafeArea(
        child: inputsAsync.when(
          data: (inputs) {
            final score = calculator(
              monthsActive: inputs.monthsActive,
              avgMonthlyRevenue: inputs.avgMonthlyRevenue,
              profitConsistency: inputs.profitConsistency,
              debtRepaymentRate: inputs.debtRepaymentRate,
            );
            final isEligibleToShare = inputs.monthsActive >= 3;

            return ListView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              children: [
                _ScoreGauge(score: score),
                const SizedBox(height: AppSizes.xl),

                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: AppStrings.monthsActive,
                        value: '${inputs.monthsActive}',
                        icon: Icons.calendar_month_rounded,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: _MetricCard(
                        label: 'متوسط الإيراد الشهري',
                        value: CurrencyFormatter.formatCompact(
                            inputs.avgMonthlyRevenue),
                        icon: Icons.bar_chart_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.xl),

                if (!isEligibleToShare)
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border:
                          Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_clock_outlined,
                            color: AppColors.gold, size: AppSizes.iconSm),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Text(
                            'استمر باستخدام التطبيق ${3 - inputs.monthsActive} '
                            'شهر إضافي لفتح ميزة مشاركة الملف مع الموردين',
                            style: const TextStyle(
                                fontSize: AppSizes.textXs,
                                color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: توليد share_token وفتح شاشة/رابط مشاركة فعلي
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('سيتم إنشاء رابط مشاركة الملف')),
                        );
                      },
                      icon: const Icon(Icons.share_rounded,
                          color: AppColors.primary),
                      label: const Text(AppStrings.shareProfile),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.md),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppSizes.xl),
                const Text(
                  'كيف تُحسب الدرجة؟',
                  style: TextStyle(
                      fontSize: AppSizes.textLg,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSizes.sm),
                const _FactorRow(label: 'مدة النشاط', weight: '30%'),
                const _FactorRow(label: 'متوسط الإيراد الشهري', weight: '25%'),
                const _FactorRow(label: 'ثبات الأرباح', weight: '25%'),
                const _FactorRow(label: 'انضباط تحصيل الديون', weight: '20%'),
                const SizedBox(height: AppSizes.xxl),
              ],
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => const Center(
            child: Text('تعذر حساب السجل الائتماني',
                style: TextStyle(color: AppColors.danger)),
          ),
        ),
      ),
    );
  }
}

class _ScoreGauge extends StatelessWidget {
  final int score;
  const _ScoreGauge({required this.score});

  Color get _color {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.primaryLight;
    if (score >= 40) return AppColors.gold;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: _color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation(_color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: _color),
                  ),
                  const Text('من 100',
                      style: TextStyle(
                          fontSize: AppSizes.textXs,
                          color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: 6),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              CalculateCreditScore.classify(score),
              style: TextStyle(color: _color, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSizes.iconSm),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: AppSizes.textXs, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: AppSizes.textMd,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _FactorRow extends StatelessWidget {
  final String label;
  final String weight;
  const _FactorRow({required this.label, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Text(weight,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
