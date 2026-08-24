import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/product.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _buyPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController(text: '5');
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final code = await context.push<String>('/barcode-scanner');
    if (code == null || !mounted) return;

    final existing =
        await ref.read(productRepositoryProvider).getByBarcode(code);
    if (!mounted) return;

    if (existing != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('هذا الباركود مسجّل بالفعل للمنتج: ${existing.name}'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _barcodeController.text = code);
  }

  double? get _buyPrice => double.tryParse(_buyPriceController.text);

  double? get _sellPrice => double.tryParse(_sellPriceController.text);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final product = Product(
      id: const Uuid().v4(),
      userId: ref.read(currentUserIdProvider) ?? 'local-user',
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.isEmpty ? null : _barcodeController.text,
      buyPrice: double.parse(_buyPriceController.text),
      sellPrice: double.parse(_sellPriceController.text),
      stockQty: int.parse(_stockController.text),
      minStock: int.tryParse(_minStockController.text) ?? 5,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(productRepositoryProvider).add(product);
      if (!mounted) return;
      context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر إضافة المنتج: $error')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.addProduct)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              Text(
                'معلومات المنتج',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSizes.xs),
              const Text(
                'أدخل السعر والمخزون ليصبح المنتج جاهزاً لتسجيل البيع.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.textSm,
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: AppStrings.productName,
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                validator: (value) => Validators.required(value,
                    fieldName: AppStrings.productName),
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.barcode,
                        hintText: 'اختياري',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Container(
                    height: AppSizes.inputHeight,
                    width: AppSizes.inputHeight,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: IconButton(
                      onPressed: _isLoading ? null : _scanBarcode,
                      icon: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: AppColors.primary,
                      ),
                      tooltip: AppStrings.scanBarcode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buyPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.buyPrice,
                        suffixText: 'ر.ي',
                      ),
                      validator: Validators.amount,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _sellPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.sellPrice,
                        suffixText: 'ر.ي',
                      ),
                      validator: Validators.amount,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              if (_buyPrice != null && _sellPrice != null) ...[
                const SizedBox(height: AppSizes.md),
                _PricePreview(buyPrice: _buyPrice!, sellPrice: _sellPrice!),
              ],
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.stockQty,
                        suffixText: 'قطعة',
                      ),
                      validator: Validators.quantity,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _minStockController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: AppStrings.minStock,
                        suffixText: 'قطعة',
                      ),
                      validator: Validators.quantity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xs),
              const Text(
                'سيظهر تنبيه عند انخفاض الكمية إلى حد إعادة التعبئة.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.textXs,
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              AppButton(
                label: AppStrings.save,
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricePreview extends StatelessWidget {
  final double buyPrice;
  final double sellPrice;

  const _PricePreview({required this.buyPrice, required this.sellPrice});

  @override
  Widget build(BuildContext context) {
    final difference = sellPrice - buyPrice;
    final isProfitable = difference >= 0;
    final color = isProfitable ? AppColors.success : AppColors.danger;
    final margin = sellPrice == 0 ? 0 : (difference / sellPrice) * 100;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Icon(
            isProfitable
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isProfitable ? 'ربح متوقع للقطعة' : 'خسارة متوقعة للقطعة',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.textXs,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${CurrencyFormatter.format(difference.abs())} · هامش ${margin.abs().toStringAsFixed(0)}%',
                  style: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
