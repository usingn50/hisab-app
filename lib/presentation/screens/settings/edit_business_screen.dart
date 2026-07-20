import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/app_user.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';

/// أنواع النشاط الشائعة في السياق اليمني — تُعرض كخيارات سريعة بدلاً من
/// حقل نص حر، لتحسين جودة البيانات (يفيد لاحقاً في تحليلات السجل الائتماني).
const _businessTypes = [
  'بقالة',
  'مطعم / كافيه',
  'ملابس',
  'إلكترونيات',
  'مواد بناء',
  'خدمات',
  'عام',
];

class EditBusinessScreen extends ConsumerStatefulWidget {
  final AppUser user;
  const EditBusinessScreen({super.key, required this.user});

  @override
  ConsumerState<EditBusinessScreen> createState() =>
      _EditBusinessScreenState();
}

class _EditBusinessScreenState extends ConsumerState<EditBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late String _selectedType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.businessName);
    _cityController = TextEditingController(
      text: widget.user.city == '—' ? '' : widget.user.city,
    );
    // إن كان النوع المحفوظ غير موجود في القائمة (قيمة قديمة/افتراضية)
    // نبدأ بـ "عام" بدلاً من قيمة غير معروضة في الواجهة.
    _selectedType = _businessTypes.contains(widget.user.businessType)
        ? widget.user.businessType
        : 'عام';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(userRepositoryProvider).updateBusinessInfo(
            id: widget.user.id,
            businessName: _nameController.text.trim(),
            businessType: _selectedType,
            city: _cityController.text.trim().isEmpty
                ? '—'
                : _cityController.text.trim(),
          );

      if (!mounted) return;
      // يُبطل الـ provider في شاشة الإعدادات كي يُعاد جلب الاسم الجديد فوراً
      ref.invalidate(currentUserProfileProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.profileUpdated),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر حفظ التعديلات: $e'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.editProfile)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.businessName,
                ),
                validator: (v) => Validators.required(
                  v,
                  fieldName: AppStrings.businessName,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              Text(AppStrings.businessType,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSizes.sm),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: _businessTypes.map((type) {
                  final selected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedType = type),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary.withValues(alpha: 0.18),
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: selected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSizes.lg),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: AppStrings.city,
                ),
              ),

              const SizedBox(height: AppSizes.xl),
              AppButton(
                label: AppStrings.saveChanges,
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
