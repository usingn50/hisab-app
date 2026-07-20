import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/product.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';

/// شاشة إضافة منتج جديد للمخزون.
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

    // تحقق من عدم وجود منتج آخر بنفس الباركود قبل الملء
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final product = Product(
      id: const Uuid().v4(),
      userId: ref.read(currentUserIdProvider) ?? 'local-user',
      name: _nameController.text.trim(),
      barcode:
          _barcodeController.text.isEmpty ? null : _barcodeController.text,
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر إضافة المنتج: $e')),
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
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: AppStrings.productName),
                validator: (v) =>
                    Validators.required(v, fieldName: AppStrings.productName),
              ),
              const SizedBox(height: AppSizes.md),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      decoration:
                          const InputDecoration(labelText: AppStrings.barcode),
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
                      onPressed: _scanBarcode,
                      icon: const Icon(Icons.qr_code_scanner_rounded,
                          color: AppColors.primary),
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
                          decimal: true),
                      decoration:
                          const InputDecoration(labelText: AppStrings.buyPrice),
                      validator: Validators.amount,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _sellPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: AppStrings.sellPrice),
                      validator: Validators.amount,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: AppStrings.stockQty),
                      validator: Validators.quantity,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _minStockController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: AppStrings.minStock),
                      validator: Validators.quantity,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.xl),
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
