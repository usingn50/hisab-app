import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/currency.dart';

class StatCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isPositive;
  final CurrencyCode currency;

  const StatCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.isPositive = true,
    this.currency = CurrencyCode.yer,
  });

  Color get _effectiveColor => amount == 0 ? AppColors.textSecondary : color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: _effectiveColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: _effectiveColor.withValues(alpha: 0.22),
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _effectiveColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: _effectiveColor, size: AppSizes.iconMd),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppSizes.textXs,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            CurrencyFormatter.formatNumberOnly(amount),
            style: const TextStyle(
              fontSize: AppSizes.textXl,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            currency.symbol,
            style: const TextStyle(
              fontSize: AppSizes.textXs,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
