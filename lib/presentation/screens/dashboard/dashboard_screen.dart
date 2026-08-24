import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/entities/transaction.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_main_navigation.dart';
import '../../widgets/common/app_state_view.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider) ?? 'local-user';
    final overview = ref.watch(dashboardOverviewProvider(currentUserId));
    final profile = ref.watch(currentUserProfileProvider);
    final businessName = profile.maybeWhen(
      data: (user) => user?.businessName.trim().isNotEmpty == true
          ? user!.businessName
          : AppStrings.appName,
      orElse: () => AppStrings.appName,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppMainNavigation(currentIndex: 0),
      body: SafeArea(
        child: overview.when(
          data: (data) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardOverviewProvider(currentUserId));
              await ref.read(dashboardOverviewProvider(currentUserId).future);
            },
            child: _DashboardContent(
              overview: data,
              businessName: businessName,
            ),
          ),
          loading: () => const AppLoadingState(label: 'جاري تحميل لوحة التحكم'),
          error: (_, __) => AppErrorState(
            title: 'تعذر تحميل لوحة التحكم',
            description: 'أعد المحاولة لتحميل آخر ملخص للمتجر.',
            onRetry: () =>
                ref.invalidate(dashboardOverviewProvider(currentUserId)),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardOverview overview;
  final String businessName;

  const _DashboardContent({required this.overview, required this.businessName});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.lg,
        AppSizes.screenPadding,
        AppSizes.xxl,
      ),
      children: [
        _DashboardHeader(businessName: businessName),
        const SizedBox(height: AppSizes.lg),
        _FinancialReportCard(report: overview.report),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/add-sale'),
            icon: const Icon(Icons.point_of_sale_rounded),
            label: const Text('تسجيل بيع'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: _SecondaryAction(
                label: 'متابعة الديون',
                icon: Icons.account_balance_wallet_outlined,
                onTap: () => context.go('/customers'),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _SecondaryAction(
                label: AppStrings.addExpense,
                icon: Icons.receipt_long_outlined,
                onTap: () => context.push('/add-expense'),
              ),
            ),
          ],
        ),
        if (overview.totalDebt > 0 || overview.lowStockCount > 0) ...[
          const SizedBox(height: AppSizes.xl),
          const Text(
            'يحتاج متابعة',
            style: TextStyle(
              fontSize: AppSizes.textLg,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          if (overview.totalDebt > 0)
            AppStatusBanner(
              tone: AppStatusTone.warning,
              icon: Icons.account_balance_wallet_outlined,
              title: 'مستحقات العملاء',
              description: CurrencyFormatter.format(overview.totalDebt),
              onTap: () => context.go('/customers'),
            ),
          if (overview.totalDebt > 0 && overview.lowStockCount > 0)
            const SizedBox(height: AppSizes.sm),
          if (overview.lowStockCount > 0)
            AppStatusBanner(
              tone: AppStatusTone.warning,
              icon: Icons.inventory_2_outlined,
              title: 'مخزون يحتاج تعبئة',
              description: '${overview.lowStockCount} منتجات منخفضة المخزون',
              onTap: () => context.go('/products'),
            ),
        ],
        const SizedBox(height: AppSizes.xl),
        const Text(
          AppStrings.recentTransactions,
          style: TextStyle(
            fontSize: AppSizes.textLg,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        if (overview.recentTransactions.isEmpty)
          const _EmptyActivity()
        else
          ...overview.recentTransactions.map(
            (transaction) => _TransactionTile(transaction: transaction),
          ),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String businessName;

  const _DashboardHeader({required this.businessName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormatter.formatFull(DateTime.now()),
                style: const TextStyle(
                  fontSize: AppSizes.textSm,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                businessName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: AppSizes.textXl,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.md),
        IconButton(
          tooltip: AppStrings.settings,
          onPressed: () => context.push('/settings'),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}

class _FinancialReportCard extends StatelessWidget {
  final Report report;

  const _FinancialReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final hasActivity = report.revenue != 0 || report.expenses != 0;
    final isProfit = report.profit > 0;
    final isLoss = report.profit < 0;
    final resultColor = isProfit
        ? AppColors.success
        : isLoss
            ? AppColors.danger
            : AppColors.primary;
    final resultLabel = !hasActivity
        ? 'نتيجة اليوم'
        : isProfit
            ? 'صافي الربح'
            : isLoss
                ? 'صافي الخسارة'
                : 'تعادل اليوم';
    final resultDescription = !hasActivity
        ? 'سجّل أول بيع لتبدأ قراءة الأداء المالي.'
        : isProfit
            ? 'هامش ربح ${report.profitMargin.toStringAsFixed(0)}% اليوم.'
            : isLoss
                ? 'المصروفات أعلى من الإيرادات اليوم.'
                : 'تساوت الإيرادات والمصروفات اليوم.';

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(
                  Icons.insights_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              const Expanded(
                child: Text(
                  'التقرير المالي اليومي',
                  style: TextStyle(
                    fontSize: AppSizes.textMd,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/reports'),
                child: const Text('التفاصيل'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resultLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.textSm,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(report.profit),
                  style: TextStyle(
                    color: resultColor,
                    fontSize: AppSizes.textXxl,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  resultDescription,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
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
                child: _FinancialMetric(
                  label: AppStrings.revenue,
                  value: report.revenue,
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: _FinancialMetric(
                  label: AppStrings.expenses,
                  value: report.expenses,
                  icon: Icons.trending_down_rounded,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          const Text(
            'القيم موحّدة حسب العملة الأساسية للنشاط.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSizes.textXs,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialMetric extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;

  const _FinancialMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = value == 0 ? AppColors.textSecondary : color;

    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: effectiveColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSizes.textXs,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              CurrencyFormatter.format(value),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.textMd,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: AppSizes.iconSm),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderLight),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'لا توجد حركة اليوم بعد',
      description: 'ابدأ بتسجيل أول بيع لتظهر حركة يومك هنا.',
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isSale = transaction.isSale;
    final title = transaction.notes?.trim().isNotEmpty == true
        ? transaction.notes!
        : (isSale ? AppStrings.addSale : AppStrings.addExpense);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isSale ? AppColors.success : AppColors.danger).withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSale
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: AppSizes.iconSm,
              color: isSale ? AppColors.success : AppColors.danger,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppSizes.textSm,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatRelative(transaction.createdAt),
                  style: const TextStyle(
                    fontSize: AppSizes.textXs,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatSigned(
              transaction.amount,
              isIncome: isSale,
            ),
            style: TextStyle(
              fontSize: AppSizes.textSm,
              fontWeight: FontWeight.w800,
              color: isSale ? AppColors.success : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}
