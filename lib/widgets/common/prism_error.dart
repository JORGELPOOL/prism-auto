import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'prism_button.dart';

/// PRISM's shared inline error state. COPIED unmodified from prism_appbloc's
/// widgets/common/prism_error.dart.
class PrismError extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const PrismError({super.key, required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: AppColors.error, size: 28),
        const SizedBox(height: 12),
        Text(message, style: AppTextStyles.bodyM.copyWith(color: AppColors.error), textAlign: TextAlign.center),
        if (actionLabel != null) ...[
          const SizedBox(height: 16),
          PrismButton(label: actionLabel!, onPressed: onAction, variant: PrismButtonVariant.ghost),
        ],
      ],
    );
  }
}
