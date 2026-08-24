import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';

class AppCurrencyConversionHint extends StatelessWidget {
  final double amount;
  final double exchangeRate;

  const AppCurrencyConversionHint({
    super.key,
    required this.amount,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    final baseAmount = amount * exchangeRate;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Text(
        'يعادل تقريباً ${CurrencyFormatter.format(baseAmount)} بسعر الصرف المدخل.',
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.textXs,
        ),
      ),
    );
  }
}
