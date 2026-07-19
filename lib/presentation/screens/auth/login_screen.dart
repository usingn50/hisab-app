import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';

/// شاشة تسجيل الدخول — اعتماد رقم الهاتف اليمني فقط، بدون كلمات مرور.
/// هذا يقلل الاحتكاك لمستخدمين غير معتادين على التطبيقات.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFocused = false;

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
  );

  late final Animation<Offset> _slideHero = Tween<Offset>(
    begin: const Offset(0, -0.15),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
  ));

  late final Animation<Offset> _slideForm = Tween<Offset>(
    begin: const Offset(0, 0.12),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
  ));

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() {
      setState(() => _isFocused = _phoneFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    _entrance.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();

    setState(() => _isLoading = true);

    final phone = '+967${_phoneController.text}';
    final result = await ref.read(authRepositoryProvider).sendOtp(phone);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case SendOtpSuccess():
        context.push('/otp', extra: phone);
      case SendOtpFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ===== خلفية زخرفية متدرجة (تعكس هوية العلامة الخضراء/الذهبية) =====
          const _AmbientBackground(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppSizes.screenPadding,
                AppSizes.md,
                AppSizes.screenPadding,
                AppSizes.lg + bottomInset,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSizes.md),

                    // ===== الهوية: الشعار + اسم التطبيق =====
                    FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slideHero,
                        child: const _BrandHeader(),
                      ),
                    ),

                    const SizedBox(height: AppSizes.xxl),

                    // ===== بطاقة تسجيل الدخول =====
                    FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slideForm,
                        child: _LoginCard(
                          formKey: _formKey,
                          phoneController: _phoneController,
                          phoneFocus: _phoneFocus,
                          isFocused: _isFocused,
                          isLoading: _isLoading,
                          onSubmit: _submit,
                        ),
                      ),
                    ),

                    const Spacer(),
                    const SizedBox(height: AppSizes.lg),

                    FadeTransition(
                      opacity: _fade,
                      child: const _TrustFooter(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// خلفية متحركة هادئة: توهجات دائرية بألوان العلامة التجارية خلف محتوى الشاشة.
class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  Color(0xFF0B2A18), // أخضر داكن جداً يمتزج بالخلفية
                ],
              ),
            ),
          ),
          Positioned(
            top: -90,
            right: -70,
            child: _GlowCircle(
              size: 260,
              color: AppColors.gold.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -100,
            child: _GlowCircle(
              size: 320,
              color: AppColors.primary.withValues(alpha: 0.14),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}

/// شعار التطبيق واسمه وشعاره التسويقي.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.background,
            size: 34,
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.appTagline,
          style: TextStyle(
            fontSize: AppSizes.textMd,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

/// بطاقة الإدخال الرئيسية: عنوان + حقل الهاتف + زر المتابعة.
class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final FocusNode phoneFocus;
  final bool isFocused;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _LoginCard({
    required this.formKey,
    required this.phoneController,
    required this.phoneFocus,
    required this.isFocused,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.enterPhone,
              style: TextStyle(
                fontSize: AppSizes.textXl,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            const Text(
              'سنرسل لك رمز تحقق عبر رسالة نصية لتأكيد رقمك',
              style: TextStyle(
                fontSize: AppSizes.textSm,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // ===== حقل رقم الهاتف مع كود الدولة الثابت =====
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color:
                      isFocused ? AppColors.primary : AppColors.borderLight,
                  width: isFocused ? 1.6 : 1,
                ),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    height: AppSizes.inputHeight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(AppSizes.radiusMd - 1),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag_rounded,
                            size: AppSizes.iconSm,
                            color: AppColors.primaryLight),
                        SizedBox(width: 6),
                        Text(
                          '+967',
                          style: TextStyle(
                            fontSize: AppSizes.textMd,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      focusNode: phoneFocus,
                      keyboardType: TextInputType.phone,
                      maxLength: 9,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: AppSizes.textMd,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: AppStrings.phoneHint,
                        counterText: '',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.md,
                        ),
                      ),
                      validator: Validators.phone,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xl),
            AppButton(
              label: AppStrings.sendOtp,
              icon: Icons.arrow_back_rounded,
              isLoading: isLoading,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

/// شريط ثقة أسفل الشاشة يبني اطمئنان المستخدم على بياناته.
class _TrustFooter extends StatelessWidget {
  const _TrustFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_user_rounded,
            size: AppSizes.iconSm,
            color: AppColors.textSecondary.withValues(alpha: 0.7)),
        const SizedBox(width: AppSizes.xs),
        Text(
          'بياناتك محفوظة محلياً على جهازك ومشفّرة بالكامل',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppSizes.textXs,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
