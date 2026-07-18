import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';

// TODO: استبدال هذا بمعرّف المستخدم الفعلي من جلسة تسجيل الدخول
const _currentUserId = 'local-user';

/// فئات المصاريف الشائعة لدى أصحاب المحلات اليمنية — تسريع الإدخال.
const _expenseCategories = [
  'كهرباء / مولد',
  'إيجار المحل',
  'مشتريات بضاعة',
  'مواصلات',
  'صيانة',
  'رواتب',
  'أخرى',
];

/// شاشة إضافة مصروف — أبسط من البيع لأنها لا ترتبط بمخزون أو زبون.
class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notes = [
      if (_selectedCategory != null) _selectedCategory,
      if (_notesController.text.isNotEmpty) _notesController.text,
    ].join(' — ');

    final notifier = ref.read(transactionFormNotifierProvider.notifier);
    await notifier.submitExpense(
      userId: _currentUserId,
      amount: double.parse(_amountController.text),
      notes: notes.isEmpty ? null : notes,
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.addExpense)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                style: const TextStyle(
                  fontSize: AppSizes.textXxl,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: AppStrings.amount,
                  suffixText: 'ريال',
                ),
                validator: Validators.amount,
              ),
              const SizedBox(height: AppSizes.lg),
              Text('نوع المصروف',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSizes.sm),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: _expenseCategories.map((cat) {
                  final selected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.danger.withValues(alpha: 0.18),
                    labelStyle: TextStyle(
                      color:
                          selected ? AppColors.danger : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: selected ? AppColors.danger : AppColors.border,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.lg),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: AppStrings.notes),
              ),
              const SizedBox(height: AppSizes.xl),
              AppButton(
                label: AppStrings.save,
                style: AppButtonStyle.danger,
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
