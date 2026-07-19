import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/transaction.dart';
import '../../providers/injection.dart';
import '../../widgets/dashboard/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentUserId = ref.watch(currentUserIdProvider) ?? 'local-user';
    final overview = ref.watch(dashboardOverviewProvider(_currentUserId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: overview.when(
          data: (data) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardOverviewProvider(_currentUserId));
              await ref.read(dashboardOverviewProvider(_currentUserId).future);
            },
            child: _DashboardContent(overview: data),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => _DashboardError(
            onRetry: () =>
                ref.invalidate(dashboardOverviewProvider(_currentUserId)),
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardOverview overview;

  const _DashboardContent({required this.overview});

  @override
  Widget build(BuildContext context) {
    final report = overview.report;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                const Text(
                  'مرحباً بك',
                  style: TextStyle(
                    fontSize: AppSizes.textXl,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  onTap: () => context.push('/settings'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.todayProfit,
                style: TextStyle(
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
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: AppStrings.todaySales,
                amount: report.revenue,
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: StatCard(
                label: AppStrings.todayExpenses,
                amount: report.expenses,
                icon: Icons.trending_down_rounded,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        StatCard(
          label: AppStrings.totalDebt,
          amount: overview.totalDebt,
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.gold,
        ),
        const SizedBox(height: AppSizes.lg),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                label: AppStrings.addSale,
                icon: Icons.point_of_sale_rounded,
                color: AppColors.primary,
                onTap: () => context.push('/add-sale'),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _QuickAction(
                label: AppStrings.addExpense,
                icon: Icons.receipt_long_rounded,
                color: AppColors.danger,
                onTap: () => context.push('/add-expense'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        const Text(
          AppStrings.recentTransactions,
          style: TextStyle(
            fontSize: AppSizes.textLg,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        if (overview.recentTransactions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
            child: Center(
              child: Text(
                'لا توجد عمليات مسجلة بعد',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ...overview.recentTransactions
              .map((transaction) => _TransactionTile(transaction: transaction)),
        const SizedBox(height: AppSizes.xxl),
      ],
    );
  }
}

class _DashboardError extends StatelessWidget {
  final VoidCallback onRetry;

  const _DashboardError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 160),
        const Icon(
          Icons.cloud_off_rounded,
          color: AppColors.textSecondary,
          size: AppSizes.iconLg,
        ),
        const SizedBox(height: AppSizes.md),
        const Center(child: Text('تعذر تحميل بيانات لوحة التحكم')),
        TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppSizes.iconLg),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: AppSizes.textSm,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
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
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isSale ? AppColors.success : AppColors.danger)
                  .withValues(alpha: 0.12),
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
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppSizes.textSm,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            CurrencyFormatter.formatSigned(transaction.amount,
                isIncome: isSale),
            style: TextStyle(
              fontSize: AppSizes.textSm,
              fontWeight: FontWeight.w700,
              color: isSale ? AppColors.success : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 1:
            context.push('/products');
            break;
          case 2:
            context.push('/customers');
            break;
          case 3:
            context.push('/reports');
            break;
          case 4:
            context.push('/credit');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'المنتجات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline_rounded),
          label: 'الزبائن',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'التقارير',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.verified_outlined),
          label: 'الائتمان',
        ),
      ],
    );
  }
}
