import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum PrismButtonVariant { primary, ghost }

/// PRISM's shared button. COPIED unmodified from prism_appbloc's
/// widgets/common/prism_button.dart — zero radius, height 48, primary = solid
/// cyan fill, ghost = bordered outline.
class PrismButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final PrismButtonVariant variant;
  final IconData? icon;
  final bool fullWidth;
  final bool loading;

  const PrismButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PrismButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == PrismButtonVariant.primary;
    final Color bg = isPrimary ? AppColors.cyan : Colors.transparent;
    final Color fg = isPrimary ? AppColors.bgPrimary : AppColors.textMist;

    return SizedBox(
      height: AppSpacing.buttonHeight,
      width: fullWidth ? double.infinity : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          border: isPrimary ? null : Border.all(color: AppColors.border2, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (loading || onPressed == null) ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                    )
                  else ...[
                    if (icon != null) ...[
                      Icon(icon, size: 16, color: fg),
                      const SizedBox(width: 8),
                    ],
                    Text(label, style: AppTextStyles.buttonLabel.copyWith(color: fg)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
