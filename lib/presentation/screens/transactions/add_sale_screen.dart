import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/entities/transaction.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';

// TODO: استبدال هذا بمعرّف المستخدم الفعلي من جلسة تسجيل الدخول
const _currentUserId = 'local-user';

final _userProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(productRepositoryProvider).getAll(_currentUserId);
});

final _userCustomersProvider = FutureProvider<List<Customer>>((ref) async {
  return ref.watch(customerRepositoryProvider).getAll(_currentUserId);
});

/// شاشة إضافة عملية بيع — نقدي أو آجل، مرتبطة بمنتج وزبون اختياري.
class AddSaleScreen extends ConsumerStatefulWidget {
  const AddSaleScreen({super.key});

  @override
  ConsumerState<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends ConsumerState<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _notesController = TextEditingController();

  Product? _selectedProduct;
  Customer? _selectedCustomer;
  PaymentMethod _payment = PaymentMethod.cash;

  @override
  void dispose() {
    _amountController.dispose();
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onProductSelected(Product? product) {
    setState(() {
      _selectedProduct = product;
      if (product != null) {
        final qty = int.tryParse(_qtyController.text) ?? 1;
        _amountController.text = (product.sellPrice * qty).toStringAsFixed(0);
      }
    });
  }

  void _recalculateAmount() {
    if (_selectedProduct == null) return;
    final qty = int.tryParse(_qtyController.text) ?? 1;
    _amountController.text =
        (_selectedProduct!.sellPrice * qty).toStringAsFixed(0);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار منتج')),
      );
      return;
    }
    if (_payment == PaymentMethod.credit && _selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البيع الآجل يحتاج اختيار زبون')),
      );
      return;
    }

    final notifier = ref.read(transactionFormNotifierProvider.notifier);
    await notifier.submitSale(
      userId: _currentUserId,
      productId: _selectedProduct!.id,
      quantity: int.parse(_qtyController.text),
      amount: double.parse(_amountController.text),
      payment: _payment,
      customerId: _selectedCustomer?.id,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    if (!mounted) return;
    final state = ref.read(transactionFormNotifierProvider);
    if (state.isSuccess) {
      ref.read(dashboardRefreshProvider.notifier).state++;
      notifier.reset();
      context.pop();
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${state.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(transactionFormNotifierProvider);
    final productsAsync = ref.watch(_userProductsProvider);
    final customersAsync = ref.watch(_userCustomersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.addSale)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              // اختيار طريقة الدفع
              Row(
                children: [
                  Expanded(
                    child: _PaymentChip(
                      label: AppStrings.cash,
                      selected: _payment == PaymentMethod.cash,
                      color: AppColors.success,
                      onTap: () =>
                          setState(() => _payment = PaymentMethod.cash),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: _PaymentChip(
                      label: AppStrings.credit,
                      selected: _payment == PaymentMethod.credit,
                      color: AppColors.gold,
                      onTap: () =>
                          setState(() => _payment = PaymentMethod.credit),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),

              // اختيار المنتج
              Text(AppStrings.selectProduct,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSizes.xs),
              productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return _EmptyHint(
                      text: 'لا توجد منتجات بعد',
                      actionLabel: AppStrings.addProduct,
                      onTap: () => context.push('/products/add'),
                    );
                  }
                  return DropdownButtonFormField<Product>(
                    initialValue: _selectedProduct,
                    isExpanded: true,
                    items: products
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(
                                  '${p.name} — ${p.sellPrice.toStringAsFixed(0)} ريال'),
                            ))
                        .toList(),
                    onChanged: _onProductSelected,
                    decoration: const InputDecoration(
                      hintText: AppStrings.selectProduct,
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => const Text('تعذر تحميل المنتجات',
                    style: TextStyle(color: AppColors.danger)),
              ),

              const SizedBox(height: AppSizes.md),

              // الكمية والمبلغ
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'الكمية'),
                      validator: Validators.quantity,
                      onChanged: (_) => _recalculateAmount(),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: AppStrings.amount),
                      validator: Validators.amount,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.md),

              // اختيار الزبون (يظهر فقط عند الآجل أو اختياري للنقدي)
              Text(
                _payment == PaymentMethod.credit
                    ? '${AppStrings.selectCustomer} (مطلوب)'
                    : '${AppStrings.selectCustomer} (اختياري)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSizes.xs),
              customersAsync.when(
                data: (customers) {
                  if (customers.isEmpty) {
                    return _EmptyHint(
                      text: 'لا يوجد زبائن بعد',
                      actionLabel: AppStrings.addCustomer,
                      onTap: () => context.push('/customers/add'),
                    );
                  }
                  return DropdownButtonFormField<Customer>(
                    initialValue: _selectedCustomer,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('بدون زبون')),
                      ...customers.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.name),
                          )),
                    ],
                    onChanged: (c) => setState(() => _selectedCustomer = c),
                    decoration: const InputDecoration(
                      hintText: AppStrings.selectCustomer,
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => const Text('تعذر تحميل الزبائن',
                    style: TextStyle(color: AppColors.danger)),
              ),

              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: AppStrings.notes),
              ),

              const SizedBox(height: AppSizes.xl),
              AppButton(
                label: AppStrings.save,
                isLoading: formState.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _PaymentChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  final String actionLabel;
  final VoidCallback onTap;

  const _EmptyHint({
    required this.text,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(color: AppColors.textSecondary)),
          TextButton(
            onPressed: onTap,
            child: Text(actionLabel,
                style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
