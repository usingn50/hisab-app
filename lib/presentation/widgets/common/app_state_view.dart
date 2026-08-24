import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'app_button.dart';

enum AppStatusTone { neutral, info, warning, danger, success }

class AppLoadingState extends StatelessWidget {
  final String? label;

  const AppLoadingState({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: label ?? 'جاري التحميل',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: AppSizes.iconLg,
              height: AppSizes.iconLg,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: AppSizes.md),
              Text(label!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  }) : assert((actionLabel == null) == (onAction == null));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: AppSizes.iconLg, color: AppColors.info),
              ),
              const SizedBox(height: AppSizes.contentGap),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (onAction != null) ...[
                const SizedBox(height: AppSizes.contentGap),
                AppButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  fullWidth: false,
                  icon: Icons.add_rounded,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.title = 'تعذر تحميل البيانات',
    this.description = 'تأكد من الاتصال ثم حاول مرة أخرى.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.cloud_off_rounded,
      title: title,
      description: description,
      actionLabel: onRetry == null ? null : 'إعادة المحاولة',
      onAction: onRetry,
    );
  }
}

class AppStatusBanner extends StatelessWidget {
  final AppStatusTone tone;
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;

  const AppStatusBanner({
    super.key,
    required this.tone,
    required this.icon,
    required this.title,
    this.description,
    this.onTap,
  });

  Color get _color => switch (tone) {
    AppStatusTone.neutral => AppColors.textSecondary,
    AppStatusTone.info => AppColors.info,
    AppStatusTone.warning => AppColors.warning,
    AppStatusTone.danger => AppColors.danger,
    AppStatusTone.success => AppColors.success,
  };

  Color get _background => switch (tone) {
    AppStatusTone.neutral => AppColors.surfaceElevated,
    AppStatusTone.info => AppColors.infoBackground,
    AppStatusTone.warning => AppColors.warningBackground,
    AppStatusTone.danger => AppColors.dangerBackground,
    AppStatusTone.success => AppColors.successBackground,
  };

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Icon(icon, color: _color, size: AppSizes.iconMd),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _color,
                    fontSize: AppSizes.textSm,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSizes.textXs,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) const Icon(Icons.chevron_left_rounded),
        ],
      ),
    );

    return Semantics(
      button: onTap != null,
      child: Material(
        color: _background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: _color.withValues(alpha: 0.35)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
