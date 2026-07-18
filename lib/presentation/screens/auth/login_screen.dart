import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/common/app_button.dart';

/// شاشة تسجيل الدخول — اعتماد رقم الهاتف اليمني فقط، بدون كلمات مرور.
/// هذا يقلل الاحتكاك لمستخدمين غير معتادين على التطبيقات.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: استدعاء AuthRepository.sendOtp(phone) عبر sync_service / api_client
    // حالياً: محاكاة تأخير الشبكة قبل ربط الـ Backend الفعلي
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final fullPhone = '+967${_phoneController.text}';
    context.push('/otp', extra: fullPhone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xxl),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: const Icon(Icons.phone_android_rounded,
                      color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: AppSizes.lg),
                const Text(
                  AppStrings.enterPhone,
                  style: TextStyle(
                    fontSize: AppSizes.textXxl,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                const Text(
                  'سنرسل لك رمز تحقق عبر رسالة نصية',
                  style: TextStyle(
                    fontSize: AppSizes.textSm,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // حقل رقم الهاتف مع كود الدولة الثابت
                Row(
                  children: [
                    Container(
                      height: AppSizes.inputHeight,
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: const Center(
                        child: Text(
                          '+967',
                          style: TextStyle(
                            fontSize: AppSizes.textMd,
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
                        maxLength: 9,
                        style: const TextStyle(
                          fontSize: AppSizes.textMd,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText: AppStrings.phoneHint,
                          counterText: '',
                        ),
                        validator: Validators.phone,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.xl),
                AppButton(
                  label: AppStrings.sendOtp,
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
