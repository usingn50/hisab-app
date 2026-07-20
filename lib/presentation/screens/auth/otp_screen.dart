import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_button.dart';

/// شاشة التحقق من رمز OTP المرسل عبر الرسائل النصية.
class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_otpController.text.length != 6) {
      setState(() => _errorText = 'الرجاء إدخال 6 أرقام كاملة');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final result = await ref
        .read(authRepositoryProvider)
        .verifyOtp(widget.phone, _otpController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case VerifyOtpSuccess(:final userId):
        // ينشئ سجل المستخدم في جدول users عند أول دخول فقط —
        // لا يؤثر على تدفق الدخول إن فشل (يُعاد المحاولة ضمنياً في
        // الجلسة التالية لأن ensureExists idempotent).
        try {
          await ref.read(userRepositoryProvider).ensureExists(widget.phone);
        } catch (_) {
          // تجاهل: عدم توفر سجل users لا يمنع استخدام التطبيق حالياً
          // لأن userId ما زال قائماً على رقم الهاتف مباشرة.
        }
        if (!mounted) return;
        ref.read(currentUserIdProvider.notifier).state = userId;
        context.go('/dashboard');
      case VerifyOtpFailure(:final message):
        setState(() => _errorText = message);
        HapticFeedback.vibrate();
    }
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0) return;
    _startTimer();
    final result = await ref
        .read(authRepositoryProvider)
        .sendOtp(widget.phone);
    if (!mounted) return;
    switch (result) {
      case SendOtpSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال رمز جديد')),
        );
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.enterOtp,
                style: TextStyle(
                  fontSize: AppSizes.textXxl,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                '${AppStrings.otpSent} ${widget.phone}',
                style: const TextStyle(
                  fontSize: AppSizes.textSm,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // وضع التطوير — يُخفى تلقائياً عند تفعيل الـ Backend
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.25)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.developer_mode_rounded,
                        size: 16, color: AppColors.gold),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'وضع التطوير — استخدم الرمز: 123456',
                        style: TextStyle(
                            fontSize: AppSizes.textXs,
                            color: AppColors.goldLight),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: AppSizes.textXxl,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 12,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  errorText: _errorText,
                  hintText: '······',
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
              ),

              const SizedBox(height: AppSizes.lg),

              Center(
                child: TextButton(
                  onPressed: _secondsLeft == 0 ? _resend : null,
                  child: Text(
                    _secondsLeft > 0
                        ? 'إعادة الإرسال بعد $_secondsLeft ثانية'
                        : AppStrings.resendOtp,
                    style: TextStyle(
                      color: _secondsLeft == 0
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.lg),
              AppButton(
                label: AppStrings.verify,
                isLoading: _isLoading,
                onPressed: _verify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
