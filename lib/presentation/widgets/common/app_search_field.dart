import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final String semanticLabel;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      textField: true,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'مسح البحث',
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}
