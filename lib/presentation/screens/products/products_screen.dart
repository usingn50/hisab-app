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
import '../../widgets/common/app_search_field.dart';
import '../../widgets/common/app_state_view.dart';

final productsListProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'local-user';
  return ref.watch(productRepositoryProvider).getAll(userId);
});

enum _ProductFilter { all, lowStock }

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();
  _ProductFilter _filter = _ProductFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(productsListProvider);
    await ref.read(productsListProvider.future);
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _query = '';
      _filter = _ProductFilter.all;
    });
  }

  bool _matchesQuery(Product product) {
    if (_query.isEmpty) return true;
    final query = _query.toLowerCase();
    return product.name.toLowerCase().contains(query) ||
        (product.barcode?.toLowerCase().contains(query) ?? false);
  }

  @override
  Widget build(BuildContext context) {
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
            final filteredProducts = products
                .where(_matchesQuery)
                .where(
                  (product) =>
                      _filter != _ProductFilter.lowStock || product.isLowStock,
                )
                .toList();

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: filteredProducts.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.screenPadding),
                      children: [
                        _InventoryHeader(
                          productsCount: products.length,
                          lowStockCount: lowStockCount,
                        ),
                        const SizedBox(height: AppSizes.md),
                        _InventoryControls(
                          controller: _searchController,
                          query: _query,
                          filter: _filter,
                          allCount: products.length,
                          lowStockCount: lowStockCount,
                          onSearchChanged: (value) =>
                              setState(() => _query = value.trim()),
                          onFilterChanged: (filter) =>
                              setState(() => _filter = filter),
                        ),
                        const SizedBox(height: AppSizes.xxl),
                        AppEmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'لا توجد نتائج مطابقة',
                          description:
                              'جرّب تغيير كلمة البحث أو عرض كل المنتجات.',
                          actionLabel: 'إظهار كل المنتجات',
                          onAction: _resetFilters,
                        ),
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.screenPadding),
                      children: [
                        _InventoryHeader(
                          productsCount: products.length,
                          lowStockCount: lowStockCount,
                        ),
                        const SizedBox(height: AppSizes.md),
                        _InventoryControls(
                          controller: _searchController,
                          query: _query,
                          filter: _filter,
                          allCount: products.length,
                          lowStockCount: lowStockCount,
                          onSearchChanged: (value) =>
                              setState(() => _query = value.trim()),
                          onFilterChanged: (filter) =>
                              setState(() => _filter = filter),
                        ),
                        if (lowStockCount > 0) ...[
                          const SizedBox(height: AppSizes.contentGap),
                          AppStatusBanner(
                            tone: AppStatusTone.warning,
                            icon: Icons.inventory_2_outlined,
                            title: '$lowStockCount منتج بحاجة إلى إعادة تعبئة',
                            description: 'اعرض المنتجات المنخفضة قبل نفادها.',
                            onTap: () => setState(
                              () => _filter = _ProductFilter.lowStock,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.contentGap),
                        Text(
                          _query.isEmpty && _filter == _ProductFilter.all
                              ? 'كل المنتجات'
                              : '${filteredProducts.length} نتيجة',
                          style: const TextStyle(
                            fontSize: AppSizes.textSm,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ...filteredProducts.map(
                          (product) => _ProductTile(product: product),
                        ),
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

class _InventoryHeader extends StatelessWidget {
  final int productsCount;
  final int lowStockCount;

  const _InventoryHeader({
    required this.productsCount,
    required this.lowStockCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('مخزون المتجر',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                '$productsCount منتجات${lowStockCount > 0 ? ' · $lowStockCount تحتاج متابعة' : ''}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.textSm,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
      ],
    );
  }
}

class _InventoryControls extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final _ProductFilter filter;
  final int allCount;
  final int lowStockCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<_ProductFilter> onFilterChanged;

  const _InventoryControls({
    required this.controller,
    required this.query,
    required this.filter,
    required this.allCount,
    required this.lowStockCount,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchField(
          controller: controller,
          hintText: 'ابحث باسم المنتج أو الباركود',
          semanticLabel: 'بحث في المنتجات',
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
                selected: filter == _ProductFilter.all,
                onSelected: (_) => onFilterChanged(_ProductFilter.all),
              ),
              ChoiceChip(
                label: Text('منخفض المخزون ($lowStockCount)'),
                selected: filter == _ProductFilter.lowStock,
                onSelected: (_) => onFilterChanged(_ProductFilter.lowStock),
              ),
            ],
          ),
        ),
      ],
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
