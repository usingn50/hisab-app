import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/pdf_report_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/report.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_main_navigation.dart';
import '../../widgets/common/app_state_view.dart';

/// تقرير اليوم الحالي
final _todayReportProvider = FutureProvider.autoDispose<Report>((ref) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'local-user';
  final getDailyReport = ref.watch(getDailyReportProvider);
  return getDailyReport(userId: userId, date: DateTime.now());
});

/// تقارير آخر 7 أيام — لرسم المخطط البياني
final _weekReportsProvider = FutureProvider.autoDispose<List<Report>>((
  ref,
) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'local-user';
  final getDailyReport = ref.watch(getDailyReportProvider);
  final now = DateTime.now();
  final reports = <Report>[];
  for (int i = 6; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    reports.add(await getDailyReport(userId: userId, date: day));
  }
  return reports;
});

/// شاشة التقارير — تعرض ملخص اليوم ومخطط آخر 7 أيام.
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(_todayReportProvider);
    final weekAsync = ref.watch(_weekReportsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.reports),
        actions: todayAsync.maybeWhen(
          data: (report) {
            final hasData = report.revenue != 0 || report.expenses != 0;
            if (!hasData) return const [];
            return [
              IconButton(
                onPressed: () => _exportPdf(context, ref),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                tooltip: AppStrings.exportPdf,
              ),
            ];
          },
          orElse: () => const [],
        ),
      ),
      bottomNavigationBar: const AppMainNavigation(currentIndex: 3),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(_todayReportProvider);
            ref.invalidate(_weekReportsProvider);
            await Future.wait([
              ref.read(_todayReportProvider.future),
              ref.read(_weekReportsProvider.future),
            ]);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              Text(
                DateFormatter.formatFull(DateTime.now()),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.textSm,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              todayAsync.when(
                data: (report) => _TodaySummary(report: report),
                loading: () => const SizedBox(
                  height: 180,
                  child: AppLoadingState(label: 'جاري تحميل ملخص اليوم'),
                ),
                error: (_, __) => AppErrorState(
                  description: 'تعذر تحميل ملخص اليوم. أعد المحاولة للمتابعة.',
                  onRetry: () => ref.invalidate(_todayReportProvider),
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              const Text(
                'آخر 7 أيام',
                style: TextStyle(
                  fontSize: AppSizes.textLg,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              weekAsync.when(
                data: (reports) => _WeekChart(reports: reports),
                loading: () => const SizedBox(
                  height: 200,
                  child: AppLoadingState(label: 'جاري تحميل المخطط'),
                ),
                error: (_, __) => AppErrorState(
                  title: 'تعذر تحميل المخطط',
                  description: 'أعد المحاولة لعرض نتائج الأيام السبعة الأخيرة.',
                  onRetry: () => ref.invalidate(_weekReportsProvider),
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 12),
            Text('جاري تجهيز التقرير...'),
          ],
        ),
        duration: Duration(seconds: 20),
      ),
    );

    try {
      final today = await ref.read(_todayReportProvider.future);
      final week = await ref.read(_weekReportsProvider.future);
      await PdfReportService.shareReport(today: today, weekReports: week);
      messenger.hideCurrentSnackBar();
    } catch (e) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('تعذر إنشاء ملف PDF، حاول مرة أخرى'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}

class _TodaySummary extends StatelessWidget {
  final Report report;
  const _TodaySummary({required this.report});

  @override
  Widget build(BuildContext context) {
    final hasActivity = report.revenue != 0 || report.expenses != 0;
    final isNeutral = report.profit == 0;
    final colors = isNeutral
        ? const [AppColors.surfaceElevated, AppColors.surface]
        : report.profit > 0
        ? const [AppColors.success, AppColors.successLight]
        : const [AppColors.danger, Color(0xFFB91C1C)];
    final title = isNeutral ? 'نتيجة اليوم' : AppStrings.profit;
    final subtitle = !hasActivity
        ? 'لا توجد عمليات اليوم بعد'
        : isNeutral
        ? 'تعادلت الإيرادات والمصروفات اليوم'
        : 'هامش ربح ${report.profitMargin.toStringAsFixed(0)}%';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: AppSizes.textSm,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(report.profit),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppSizes.textDisplay,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: AppSizes.textXs,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: _StatBox(
                label: AppStrings.revenue,
                value: report.revenue,
                color: AppColors.success,
                icon: Icons.trending_up_rounded,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _StatBox(
                label: AppStrings.expenses,
                value: report.expenses,
                color: AppColors.danger,
                icon: Icons.trending_down_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = value == 0 ? AppColors.textSecondary : color;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: effectiveColor, size: AppSizes.iconSm),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppSizes.textXs,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            CurrencyFormatter.formatNumberOnly(value),
            style: const TextStyle(
              fontSize: AppSizes.textMd,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekChart extends StatelessWidget {
  final List<Report> reports;
  const _WeekChart({required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.every((r) => r.revenue == 0 && r.expenses == 0)) {
      return const AppEmptyState(
        icon: Icons.bar_chart_outlined,
        title: 'لا توجد بيانات كافية بعد',
        description: 'سجّل عملياتك اليومية لتظهر مؤشرات الأيام السبعة الأخيرة.',
      );
    }

    final maxY = reports
        .map((r) => r.revenue > r.expenses ? r.revenue : r.expenses)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(
        8,
        AppSizes.md,
        AppSizes.md,
        AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY == 0 ? 100 : maxY * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= reports.length) return const SizedBox();
                  final day = reports[i].startDate;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormatter.formatRelative(day),
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(reports.length, (i) {
            final r = reports[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: r.profit.abs(),
                  color: r.profit == 0
                      ? AppColors.textSecondary
                      : r.profit > 0
                      ? AppColors.success
                      : AppColors.danger,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
