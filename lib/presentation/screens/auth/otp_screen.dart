import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../widgets/common/app_button.dart';

/// شاشة التحقق من رمز OTP المرسل عبر الرسائل النصية.
class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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

    // TODO: استدعاء AuthRepository.verifyOtp(phone, code) عبر api_client
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', widget.phone);

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go('/dashboard');
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    // TODO: استدعاء AuthRepository.sendOtp(phone) مرة أخرى
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال رمز جديد')),
    );
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
              const SizedBox(height: AppSizes.xl),

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
