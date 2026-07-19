import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/credit_share_service.dart';
import '../../../core/services/session_service.dart';
import '../../providers/injection.dart';

/// شاشة الإعدادات — تعرض بيانات الحساب الحالي وتتيح تسجيل الخروج.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = ref.watch(currentUserIdProvider) ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          children: [
            // ===== بطاقة الحساب =====
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phone.isEmpty ? '—' : phone,
                          style: const TextStyle(
                            fontSize: AppSizes.textMd,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          AppStrings.account,
                          style: TextStyle(
                            fontSize: AppSizes.textXs,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // ===== تسجيل الخروج =====
            _SettingsTile(
              icon: Icons.logout_rounded,
              label: AppStrings.logout,
              iconColor: AppColors.danger,
              onTap: () => _confirmLogout(context, ref),
            ),

            const SizedBox(height: AppSizes.xxl),

            Center(
              child: Text(
                '${AppStrings.appVersion}: 1.0.0',
                style: const TextStyle(
                  fontSize: AppSizes.textXs,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(AppStrings.logoutConfirmTitle,
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(AppStrings.logoutConfirmMessage,
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.logout,
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // يمسح الجلسة المحفوظة محلياً ويصفّر مزوّد المستخدم الحالي —
    // بيانات المعاملات/المنتجات/الزبائن تبقى محفوظة بقاعدة البيانات المحلية،
    // فقط "الدخول" ينتهي، والدخول بنفس الرقم لاحقاً يرجّع نفس البيانات.
    await SessionService.clearSession();
    await CreditShareService.clearToken();
    ref.read(currentUserIdProvider.notifier).state = null;

    if (!context.mounted) return;
    context.go('/login');
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md, vertical: AppSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: AppSizes.iconMd),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.textMd,
                    fontWeight: FontWeight.w600,
                    color: iconColor == AppColors.danger
                        ? AppColors.danger
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.chevron_left_rounded,
                  color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}
