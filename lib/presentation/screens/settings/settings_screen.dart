import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/credit_share_service.dart';
import '../../../core/services/session_service.dart';
import '../../../domain/entities/app_user.dart';
import '../../providers/injection.dart';
import '../../widgets/common/app_state_view.dart';
import 'edit_business_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = ref.watch(currentUserIdProvider) ?? '';
    final profileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          children: [
            const _SectionLabel('النشاط التجاري'),
            const SizedBox(height: AppSizes.sm),
            _AccountCard(
              phone: phone,
              profileAsync: profileAsync,
              onTap: () {
                final user = profileAsync.valueOrNull;
                if (user == null) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditBusinessScreen(user: user),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.xl),
            const _SectionLabel('البيانات على هذا الجهاز'),
            const SizedBox(height: AppSizes.sm),
            const _InfoCard(
              icon: Icons.phone_android_rounded,
              title: 'يعمل التطبيق دون إنترنت',
              description:
                  'تظل المبيعات والمخزون ودفتر الديون محفوظة على هذا الجهاز حتى عند انقطاع الاتصال.',
              tone: AppStatusTone.info,
            ),
            const SizedBox(height: AppSizes.sm),
            const _InfoCard(
              icon: Icons.currency_exchange_rounded,
              title: 'العملة الأساسية للتقارير',
              description:
                  'تُوحَّد قيم المعاملات الأجنبية وفق سعر الصرف المدخل وقت تسجيل العملية.',
              tone: AppStatusTone.neutral,
            ),
            const SizedBox(height: AppSizes.xl),
            const _SectionLabel('الحساب والجلسة'),
            const SizedBox(height: AppSizes.sm),
            _SettingsTile(
              icon: Icons.logout_rounded,
              label: AppStrings.logout,
              description:
                  'تنهي جلسة هذا الرقم، مع بقاء البيانات المحلية محفوظة.',
              iconColor: AppColors.danger,
              onTap: () => _confirmLogout(context, ref),
            ),
            const SizedBox(height: AppSizes.xxl),
            const Center(
              child: Text(
                '${AppStrings.appVersion}: 1.0.0',
                style: TextStyle(
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
        title: const Text(
          AppStrings.logoutConfirmTitle,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          AppStrings.logoutConfirmMessage,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await SessionService.clearSession();
    await CreditShareService.clearToken();
    ref.read(currentUserIdProvider.notifier).state = null;

    if (!context.mounted) return;
    context.go('/login');
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: AppSizes.textSm,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final String phone;
  final AsyncValue<AppUser?> profileAsync;
  final VoidCallback onTap;

  const _AccountCard({
    required this.phone,
    required this.profileAsync,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = profileAsync.valueOrNull;
    final isReady = user != null;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        onTap: isReady ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
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
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.businessName ?? AppStrings.account,
                      style: const TextStyle(
                        fontSize: AppSizes.textMd,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phone.isEmpty ? 'جاري تحميل بيانات الحساب' : phone,
                      style: const TextStyle(
                        fontSize: AppSizes.textXs,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (isReady) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'تعديل بيانات النشاط',
                        style: TextStyle(
                          fontSize: AppSizes.textXs,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isReady)
                const Icon(Icons.chevron_left_rounded,
                    color: AppColors.textHint)
              else
                const SizedBox(
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final AppStatusTone tone;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      AppStatusTone.info => AppColors.info,
      AppStatusTone.warning => AppColors.warning,
      AppStatusTone.danger => AppColors.danger,
      AppStatusTone.success => AppColors.success,
      AppStatusTone.neutral => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: color, size: AppSizes.iconSm),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.textXs,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color iconColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.description,
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
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: AppSizes.iconMd),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppSizes.textMd,
                        fontWeight: FontWeight.w700,
                        color: iconColor == AppColors.danger
                            ? AppColors.danger
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSizes.textXs,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}
