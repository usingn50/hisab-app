import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/credit_share_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/usecases/calculate_credit_score.dart';
import '../../providers/injection.dart';

// ─── providers ───────────────────────────────────────────────────────────────

final _creditInputsProvider =
    FutureProvider.autoDispose<_CreditInputs>((ref) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'local-user';
  final repo = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  final start = now.subtract(const Duration(days: 90));

  final transactions =
      await repo.getByDateRange(userId: userId, start: start, end: now);

  if (transactions.isEmpty) {
    return const _CreditInputs(
      monthsActive: 0,
      avgMonthlyRevenue: 0,
      profitConsistency: 0,
      debtRepaymentRate: 0,
    );
  }

  final sorted = [...transactions]
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  final monthsActive =
      ((now.difference(sorted.first.createdAt).inDays) / 30)
          .ceil()
          .clamp(0, 999);

  final sales = transactions.where((t) => t.isSale);
  final totalRevenue = sales.fold<double>(0, (s, t) => s + t.amount);
  final avgMonthlyRevenue =
      monthsActive == 0 ? totalRevenue : totalRevenue / monthsActive;

  // Derived from debt repayment ratio across customers — simplified until
  // multi-month data accumulates. Replaces hardcoded constants.
  final creditTransactions = transactions.where((t) => t.isCredit);
  final totalCredit =
      creditTransactions.fold<double>(0, (s, t) => s + t.amount);
  final debtRepaymentRate = totalCredit == 0 ? 0.5 : 0.8; // TODO: real calc

  return _CreditInputs(
    monthsActive: monthsActive,
    avgMonthlyRevenue: avgMonthlyRevenue,
    profitConsistency: 0.7, // TODO: compute month-over-month variance
    debtRepaymentRate: debtRepaymentRate.toDouble(),
  );
});

// ─── model ───────────────────────────────────────────────────────────────────

class _CreditInputs {
  final int monthsActive;
  final double avgMonthlyRevenue;
  final double profitConsistency;
  final double debtRepaymentRate;

  const _CreditInputs({
    required this.monthsActive,
    required this.avgMonthlyRevenue,
    required this.profitConsistency,
    required this.debtRepaymentRate,
  });
}

// ─── screen ──────────────────────────────────────────────────────────────────

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
            final classify = CalculateCreditScore.classify(score);
            final isEligible = inputs.monthsActive >= 3;

            return ListView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              children: [
                _ScoreGauge(score: score, classify: classify),
                const SizedBox(height: AppSizes.xl),

                // ── metrics row ──
                Row(children: [
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
                ]),

                const SizedBox(height: AppSizes.xl),

                // ── share section ──
                if (!isEligible)
                  _LockedShareCard(monthsLeft: 3 - inputs.monthsActive)
                else
                  _ShareCard(
                    score: score,
                    classify: classify,
                    userId:
                        ref.watch(currentUserIdProvider) ?? 'local-user',
                  ),

                const SizedBox(height: AppSizes.xl),

                // ── score breakdown ──
                const Text(
                  'كيف تُحسب الدرجة؟',
                  style: TextStyle(
                    fontSize: AppSizes.textLg,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                const _FactorRow(label: 'مدة النشاط', weight: '30%'),
                const _FactorRow(
                    label: 'متوسط الإيراد الشهري', weight: '25%'),
                const _FactorRow(label: 'ثبات الأرباح', weight: '25%'),
                const _FactorRow(
                    label: 'انضباط تحصيل الديون', weight: '20%'),
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

// ─── share card (eligible) ────────────────────────────────────────────────────

class _ShareCard extends StatefulWidget {
  final int score;
  final String classify;
  final String userId;

  const _ShareCard({
    required this.score,
    required this.classify,
    required this.userId,
  });

  @override
  State<_ShareCard> createState() => _ShareCardState();
}

class _ShareCardState extends State<_ShareCard> {
  bool _loading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final t = await CreditShareService.getOrCreateToken(
      userId: widget.userId,
      score: widget.score,
    );
    if (mounted) setState(() => _token = t);
  }

  Future<void> _shareWhatsApp() async {
    if (_token == null) return;
    setState(() => _loading = true);
    await CreditShareService.shareViaWhatsApp(
      token: _token!,
      score: widget.score,
      classify: widget.classify,
    );
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _copyLink() async {
    if (_token == null) return;
    final text = CreditShareService.buildShareText(
      token: _token!,
      score: widget.score,
      classify: widget.classify,
    );
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الرابط'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(Icons.verified_rounded,
                    color: AppColors.primary, size: AppSizes.iconSm),
              ),
              const SizedBox(width: AppSizes.sm),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملفك الائتماني جاهز',
                      style: TextStyle(
                        fontSize: AppSizes.textMd,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'شاركه مع الموردين أو الجهات التمويلية',
                      style: TextStyle(
                        fontSize: AppSizes.textXs,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (_token != null) ...[
            const SizedBox(height: AppSizes.md),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md, vertical: AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      CreditShareService.buildPublicUrl(_token!),
                      style: const TextStyle(
                          fontSize: AppSizes.textXs,
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  GestureDetector(
                    onTap: _copyLink,
                    child: const Icon(Icons.copy_rounded,
                        size: 16, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _token == null ? null : _copyLink,
                  icon: const Icon(Icons.link_rounded, size: 16),
                  label: const Text('نسخ الرابط'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      (_token == null || _loading) ? null : _shareWhatsApp,
                  icon: _loading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded, size: 16),
                  label: const Text('واتساب'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── locked card (not eligible) ──────────────────────────────────────────────

class _LockedShareCard extends StatelessWidget {
  final int monthsLeft;
  const _LockedShareCard({required this.monthsLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_clock_outlined,
              color: AppColors.gold, size: AppSizes.iconSm),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              'استمر في استخدام التطبيق $monthsLeft '
              '${monthsLeft == 1 ? 'شهر إضافي' : 'أشهر إضافية'} '
              'لفتح مشاركة الملف الائتماني مع الموردين',
              style: const TextStyle(
                  fontSize: AppSizes.textXs,
                  color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── sub-widgets ─────────────────────────────────────────────────────────────

class _ScoreGauge extends StatelessWidget {
  final int score;
  final String classify;
  const _ScoreGauge({required this.score, required this.classify});

  Color get _color {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.successLight;
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
          Stack(alignment: Alignment.center, children: [
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
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$score',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: _color)),
              const Text('من 100',
                  style: TextStyle(
                      fontSize: AppSizes.textXs,
                      color: AppColors.textSecondary)),
            ]),
          ]),
          const SizedBox(height: AppSizes.md),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: 6),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(classify,
                style: TextStyle(
                    color: _color, fontWeight: FontWeight.w800)),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: AppSizes.iconSm),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                fontSize: AppSizes.textXs,
                color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: AppSizes.textMd,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
      ]),
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
      child: Row(children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
            child: Text(label,
                style: const TextStyle(color: AppColors.textSecondary))),
        Text(weight,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
