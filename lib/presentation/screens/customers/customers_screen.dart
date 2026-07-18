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

const _currentUserId = 'local-user';

final customersListProvider =
    FutureProvider.autoDispose<List<Customer>>((ref) async {
  return ref.watch(customerRepositoryProvider).getAll(_currentUserId);
});

/// شاشة دفتر الديون — الميزة الأهم اجتماعياً في التطبيق.
/// تعرض كل زبون مع دينه، وتسمح بإرسال تذكير واتساب بنقرة واحدة.
class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.debtBook)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/customers/add');
          ref.invalidate(customersListProvider);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text(AppStrings.addCustomer,
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: customersAsync.when(
          data: (customers) {
            if (customers.isEmpty) {
              return _EmptyState(
                onAdd: () async {
                  await context.push('/customers/add');
                  ref.invalidate(customersListProvider);
                },
              );
            }

            final totalDebt =
                customers.fold<double>(0, (sum, c) => sum + c.totalDebt);
            final overdueCount = customers.where((c) => c.isOverdue).length;

            // الزبائن المتأخرون أولاً، ثم الأعلى ديناً
            final sorted = [...customers]
              ..sort((a, b) {
                if (a.isOverdue != b.isOverdue) {
                  return a.isOverdue ? -1 : 1;
                }
                return b.totalDebt.compareTo(a.totalDebt);
              });

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => ref.invalidate(customersListProvider),
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                children: [
                  // ملخص إجمالي الديون
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(AppStrings.totalDebt,
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppSizes.textSm)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(totalDebt),
                          style: const TextStyle(
                            color: AppColors.goldLight,
                            fontSize: AppSizes.textXxl,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (overdueCount > 0) ...[
                          const SizedBox(height: 6),
                          Text(
                            '⚠ $overdueCount زبون متأخر أكثر من 30 يوماً',
                            style: const TextStyle(
                                color: AppColors.danger,
                                fontSize: AppSizes.textXs,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  ...sorted.map((c) => _CustomerTile(
                        customer: c,
                        onRemind: () => _sendWhatsAppReminder(c),
                      )),
                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => const Center(
            child: Text('تعذر تحميل الزبائن',
                style: TextStyle(color: AppColors.danger)),
          ),
        ),
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  final Customer customer;
  final VoidCallback onRemind;

  const _CustomerTile({required this.customer, required this.onRemind});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: customer.isOverdue
            ? Border.all(color: AppColors.danger.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: customer.hasDebt
                ? AppColors.gold.withValues(alpha: 0.15)
                : AppColors.success.withValues(alpha: 0.12),
            child: Text(
              customer.name.isNotEmpty ? customer.name[0] : '?',
              style: TextStyle(
                color: customer.hasDebt ? AppColors.gold : AppColors.success,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
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
                        ? AppColors.danger
                        : AppColors.textSecondary,
                    fontWeight:
                        customer.isOverdue ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                customer.hasDebt
                    ? CurrencyFormatter.formatNumberOnly(customer.totalDebt)
                    : '—',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: customer.hasDebt
                      ? AppColors.goldLight
                      : AppColors.textHint,
                ),
              ),
              if (customer.hasDebt && customer.phone != null)
                InkWell(
                  onTap: onRemind,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.send_rounded,
                        size: 16, color: AppColors.success),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline_rounded,
                size: 56, color: AppColors.textHint),
            const SizedBox(height: AppSizes.md),
            const Text('لا يوجد زبائن بعد',
                style: TextStyle(
                    fontSize: AppSizes.textLg,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: AppSizes.xs),
            const Text('أضف زبائنك لتتبع ديونهم بسهولة',
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.lg),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, color: AppColors.primary),
              label: const Text(AppStrings.addCustomer,
                  style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
