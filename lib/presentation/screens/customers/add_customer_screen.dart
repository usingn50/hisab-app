import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/customer.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_state_view.dart';

/// شاشة إضافة زبون جديد لدفتر الديون.
class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final customer = Customer(
      id: const Uuid().v4(),
      userId: ref.read(currentUserIdProvider) ?? 'local-user',
      name: _nameController.text.trim(),
      phone: _phoneController.text.isEmpty ? null : '7${_phoneController.text}',
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(customerRepositoryProvider).add(customer);
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('تعذر إضافة الزبون: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.addCustomer)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              Text(
                'بيانات الزبون',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSizes.xs),
              const Text(
                'أضف بياناته الأساسية لتتابع الرصيد والدفعات بسهولة.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.textSm,
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.customerName,
                ),
                validator: (v) =>
                    Validators.required(v, fieldName: AppStrings.customerName),
              ),
              const SizedBox(height: AppSizes.md),

              Row(
                children: [
                  Container(
                    height: AppSizes.inputHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Center(
                      child: Text(
                        '+967',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      maxLength: 9,
                      decoration: const InputDecoration(
                        labelText: AppStrings.phone,
                        hintText: AppStrings.phoneHint,
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.md),
              const AppStatusBanner(
                tone: AppStatusTone.info,
                icon: Icons.info_outline_rounded,
                title: 'رقم الهاتف اختياري',
                description:
                    'إضافته تتيح إرسال تذكير واتساب عند وجود رصيد مستحق.',
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
