import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/product.dart';
import '../../providers/injection.dart';

final productsListProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'local-user';
  return ref.watch(productRepositoryProvider).getAll(userId);
});

/// شاشة عرض كل المنتجات مع تنبيه واضح للمخزون المنخفض.
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.products)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/products/add');
          ref.invalidate(productsListProvider);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addProduct,
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return _EmptyState(
                onAdd: () async {
                  await context.push('/products/add');
                  ref.invalidate(productsListProvider);
                },
              );
            }

            final lowStockCount =
                products.where((p) => p.isLowStock).length;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => ref.invalidate(productsListProvider),
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                children: [
                  if (lowStockCount > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: AppSizes.md),
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border:
                            Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.danger, size: AppSizes.iconSm),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Text(
                              '$lowStockCount منتج بحاجة لإعادة تعبئة المخزون',
                              style: const TextStyle(
                                color: AppColors.danger,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSizes.textSm,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ...products.map((p) => _ProductTile(product: p)),
                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => const Center(
            child: Text('تعذر تحميل المنتجات',
                style: TextStyle(color: AppColors.danger)),
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: product.isLowStock
            ? Border.all(color: AppColors.danger.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                color: AppColors.primary, size: AppSizes.iconSm),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'متبقي: ${product.stockQty}',
                      style: TextStyle(
                        fontSize: AppSizes.textXs,
                        color: product.isLowStock
                            ? AppColors.danger
                            : AppColors.textSecondary,
                        fontWeight: product.isLowStock
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    if (product.isLowStock) ...[
                      const SizedBox(width: 4),
                      const Text('⚠',
                          style: TextStyle(fontSize: AppSizes.textXs)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatNumberOnly(product.sellPrice),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
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
            const Icon(Icons.inventory_2_outlined,
                size: 56, color: AppColors.textHint),
            const SizedBox(height: AppSizes.md),
            const Text('لا توجد منتجات بعد',
                style: TextStyle(
                    fontSize: AppSizes.textLg,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: AppSizes.xs),
            const Text('أضف أول منتج لتبدأ تسجيل المبيعات',
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.lg),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, color: AppColors.primary),
              label: const Text(AppStrings.addProduct,
                  style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
