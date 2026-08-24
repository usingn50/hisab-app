import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/product.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_main_navigation.dart';
import '../../widgets/common/app_state_view.dart';

final productsListProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'local-user';
  return ref.watch(productRepositoryProvider).getAll(userId);
});

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(productsListProvider);
    await ref.read(productsListProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.products)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/products/add');
          ref.invalidate(productsListProvider);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addProduct),
      ),
      bottomNavigationBar: const AppMainNavigation(currentIndex: 1),
      body: SafeArea(
        child: productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return AppEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'ابدأ بمنتجك الأكثر مبيعاً',
                description: 'أضف منتجاً واحداً على الأقل لتسجل أول عملية بيع.',
                actionLabel: AppStrings.addProduct,
                onAction: () async {
                  await context.push('/products/add');
                  ref.invalidate(productsListProvider);
                },
              );
            }

            final lowStockCount = products.where((p) => p.isLowStock).length;
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => _refresh(ref),
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                children: [
                  Text(
                    'مخزون المتجر',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSizes.itemGap),
                  if (lowStockCount > 0) ...[
                    AppStatusBanner(
                      tone: AppStatusTone.warning,
                      icon: Icons.inventory_2_outlined,
                      title: '$lowStockCount منتج بحاجة إلى إعادة تعبئة',
                      description: 'راجع المنتجات المعلَّمة قبل نفادها.',
                    ),
                    const SizedBox(height: AppSizes.contentGap),
                  ],
                  ...products.map((product) => _ProductTile(product: product)),
                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            );
          },
          loading: () => const AppLoadingState(label: 'جاري تحميل المنتجات'),
          error: (_, __) => AppErrorState(
            description: 'تعذر تحميل المنتجات. اسحب للتحديث أو أعد المحاولة.',
            onRetry: () => ref.invalidate(productsListProvider),
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final stockColor = product.isLowStock ? AppColors.warning : AppColors.info;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.itemGap),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: product.isLowStock
              ? AppColors.warning.withValues(alpha: 0.55)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.touchTarget,
            height: AppSizes.touchTarget,
            decoration: BoxDecoration(
              color: stockColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: stockColor,
              size: AppSizes.iconMd,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  product.isLowStock
                      ? 'المخزون منخفض: ${product.stockQty}'
                      : 'المخزون المتبقي: ${product.stockQty}',
                  style: TextStyle(
                    fontSize: AppSizes.textXs,
                    color: product.isLowStock
                        ? AppColors.warning
                        : AppColors.textSecondary,
                    fontWeight: product.isLowStock
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            CurrencyFormatter.format(product.sellPrice),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
