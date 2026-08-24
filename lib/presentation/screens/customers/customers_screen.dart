import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/customer.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_main_navigation.dart';
import '../../widgets/common/app_search_field.dart';
import '../../widgets/common/app_state_view.dart';

final customersListProvider = FutureProvider.autoDispose<List<Customer>>((
  ref,
) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'local-user';
  return ref.watch(customerRepositoryProvider).getAll(userId);
});

enum _CustomerFilter { all, outstanding, overdue }

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();
  _CustomerFilter _filter = _CustomerFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _sendWhatsAppReminder(Customer customer) async {
    if (customer.phone == null || customer.phone!.isEmpty) return;

    final amount = CurrencyFormatter.formatNumberOnly(customer.totalDebt);
    final message = Uri.encodeComponent(
      'السلام عليكم ${customer.name}، تذكير بخصوص رصيدكم المستحق '
      '$amount ريال. نشكر تعاونكم.',
    );
    final phone = customer.phone!.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('https://wa.me/967$phone?text=$message');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(customersListProvider);
    await ref.read(customersListProvider.future);
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _query = '';
      _filter = _CustomerFilter.all;
    });
  }

  bool _matchesQuery(Customer customer) {
    if (_query.isEmpty) return true;
    final query = _query.toLowerCase();
    return customer.name.toLowerCase().contains(query) ||
        (customer.phone?.contains(query) ?? false);
  }

  bool _matchesFilter(Customer customer) {
    return switch (_filter) {
      _CustomerFilter.all => true,
      _CustomerFilter.outstanding => customer.hasDebt,
      _CustomerFilter.overdue => customer.isOverdue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.debtBook)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/customers/add');
          ref.invalidate(customersListProvider);
        },
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text(AppStrings.addCustomer),
      ),
      bottomNavigationBar: const AppMainNavigation(currentIndex: 2),
      body: SafeArea(
        child: customersAsync.when(
          data: (customers) {
            if (customers.isEmpty) {
              return AppEmptyState(
                icon: Icons.people_outline_rounded,
                title: 'ابدأ بأول زبون',
                description: 'أضف زبائنك لتتابع أرصدتهم ودفعاتهم بسهولة.',
                actionLabel: AppStrings.addCustomer,
                onAction: () async {
                  await context.push('/customers/add');
                  ref.invalidate(customersListProvider);
                },
              );
            }

            final totalDebt = customers.fold<double>(
              0,
              (sum, customer) => sum + customer.totalDebt,
            );
            final outstandingCount = customers.where((c) => c.hasDebt).length;
            final overdueCount = customers.where((c) => c.isOverdue).length;
            final sorted = [...customers]..sort((a, b) {
                if (a.isOverdue != b.isOverdue) {
                  return a.isOverdue ? -1 : 1;
                }
                return b.totalDebt.compareTo(a.totalDebt);
              });
            final filtered =
                sorted.where(_matchesQuery).where(_matchesFilter).toList();

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: filtered.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.screenPadding),
                      children: [
                        _DebtSummary(
                          totalDebt: totalDebt,
                          customersCount: customers.length,
                          overdueCount: overdueCount,
                        ),
                        const SizedBox(height: AppSizes.md),
                        _CustomerControls(
                          controller: _searchController,
                          filter: _filter,
                          allCount: customers.length,
                          outstandingCount: outstandingCount,
                          overdueCount: overdueCount,
                          onSearchChanged: (value) =>
                              setState(() => _query = value.trim()),
                          onFilterChanged: (filter) =>
                              setState(() => _filter = filter),
                        ),
                        const SizedBox(height: AppSizes.xxl),
                        AppEmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'لا توجد نتائج مطابقة',
                          description: 'جرّب اسمًا آخر أو اعرض كل الزبائن.',
                          actionLabel: 'إظهار كل الزبائن',
                          onAction: _resetFilters,
                        ),
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.screenPadding),
                      children: [
                        _DebtSummary(
                          totalDebt: totalDebt,
                          customersCount: customers.length,
                          overdueCount: overdueCount,
                        ),
                        const SizedBox(height: AppSizes.md),
                        _CustomerControls(
                          controller: _searchController,
                          filter: _filter,
                          allCount: customers.length,
                          outstandingCount: outstandingCount,
                          overdueCount: overdueCount,
                          onSearchChanged: (value) =>
                              setState(() => _query = value.trim()),
                          onFilterChanged: (filter) =>
                              setState(() => _filter = filter),
                        ),
                        if (overdueCount > 0) ...[
                          const SizedBox(height: AppSizes.contentGap),
                          AppStatusBanner(
                            tone: AppStatusTone.warning,
                            icon: Icons.schedule_rounded,
                            title: '$overdueCount زبون متأخر أكثر من 30 يوماً',
                            description: 'اعرضهم لتحديث الرصيد أو تسجيل دفعة.',
                            onTap: () => setState(
                              () => _filter = _CustomerFilter.overdue,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.contentGap),
                        Text(
                          _query.isEmpty && _filter == _CustomerFilter.all
                              ? 'كل الزبائن'
                              : '${filtered.length} نتيجة',
                          style: const TextStyle(
                            fontSize: AppSizes.textSm,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ...filtered.map(
                          (customer) => _CustomerTile(
                            customer: customer,
                            onRemind: () => _sendWhatsAppReminder(customer),
                          ),
                        ),
                        const SizedBox(height: AppSizes.xxl),
                      ],
                    ),
            );
          },
          loading: () => const AppLoadingState(label: 'جاري تحميل الزبائن'),
          error: (_, __) => AppErrorState(
            description: 'تعذر تحميل دفتر الديون. أعد المحاولة للمتابعة.',
            onRetry: () => ref.invalidate(customersListProvider),
          ),
        ),
      ),
    );
  }
}

class _DebtSummary extends StatelessWidget {
  final double totalDebt;
  final int customersCount;
  final int overdueCount;

  const _DebtSummary({
    required this.totalDebt,
    required this.customersCount,
    required this.overdueCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasDebt = totalDebt > 0;
    final accent = hasDebt ? AppColors.gold : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.totalDebt,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSizes.textSm,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            CurrencyFormatter.format(totalDebt),
            style: TextStyle(
              color: accent,
              fontSize: AppSizes.textXxl,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            hasDebt
                ? '$customersCount زبائن مسجلين${overdueCount > 0 ? ' · $overdueCount متأخرين' : ''}'
                : 'لا توجد أرصدة مستحقة حالياً',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSizes.textXs,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerControls extends StatelessWidget {
  final TextEditingController controller;
  final _CustomerFilter filter;
  final int allCount;
  final int outstandingCount;
  final int overdueCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<_CustomerFilter> onFilterChanged;

  const _CustomerControls({
    required this.controller,
    required this.filter,
    required this.allCount,
    required this.outstandingCount,
    required this.overdueCount,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchField(
          controller: controller,
          hintText: 'ابحث باسم الزبون أو رقم الهاتف',
          semanticLabel: 'بحث في الزبائن',
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: AppSizes.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Wrap(
            spacing: AppSizes.xs,
            runSpacing: AppSizes.xs,
            children: [
              ChoiceChip(
                label: Text('الكل ($allCount)'),
                selected: filter == _CustomerFilter.all,
                onSelected: (_) => onFilterChanged(_CustomerFilter.all),
              ),
              ChoiceChip(
                label: Text('عليهم رصيد ($outstandingCount)'),
                selected: filter == _CustomerFilter.outstanding,
                onSelected: (_) => onFilterChanged(_CustomerFilter.outstanding),
              ),
              ChoiceChip(
                label: Text('متأخرون ($overdueCount)'),
                selected: filter == _CustomerFilter.overdue,
                onSelected: (_) => onFilterChanged(_CustomerFilter.overdue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomerTile extends StatelessWidget {
  final Customer customer;
  final VoidCallback onRemind;

  const _CustomerTile({required this.customer, required this.onRemind});

  @override
  Widget build(BuildContext context) {
    final debtAccent =
        customer.hasDebt ? AppColors.gold : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.itemGap),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: customer.isOverdue
              ? AppColors.warning.withValues(alpha: 0.6)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: debtAccent.withValues(alpha: 0.15),
            child: Text(
              customer.name.isNotEmpty ? customer.name[0] : '?',
              style: TextStyle(color: debtAccent, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  customer.hasDebt
                      ? (customer.daysSinceLastPayment != null
                          ? 'آخر دفعة منذ ${customer.daysSinceLastPayment} يوم'
                          : 'لم يسدد بعد')
                      : AppStrings.noDebt,
                  style: TextStyle(
                    fontSize: AppSizes.textXs,
                    color: customer.isOverdue
                        ? AppColors.warning
                        : AppColors.textSecondary,
                    fontWeight: customer.isOverdue
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                customer.hasDebt
                    ? CurrencyFormatter.formatNumberOnly(customer.totalDebt)
                    : '—',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: debtAccent,
                ),
              ),
              if (customer.hasDebt && customer.phone != null)
                IconButton(
                  tooltip: 'إرسال تذكير',
                  onPressed: onRemind,
                  icon: const Icon(
                    Icons.send_rounded,
                    size: AppSizes.iconSm,
                    color: AppColors.success,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
