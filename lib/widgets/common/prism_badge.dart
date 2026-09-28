import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum PrismBadgeStatus { pending, success, error, info }

/// PRISM's shared status badge. COPIED unmodified from prism_appbloc's
/// widgets/common/prism_badge.dart.
class PrismBadge extends StatelessWidget {
  final String label;
  final PrismBadgeStatus status;

  const PrismBadge({super.key, required this.label, this.status = PrismBadgeStatus.info});

  Color get _color {
    switch (status) {
      case PrismBadgeStatus.pending:
        return AppColors.warning;
      case PrismBadgeStatus.success:
        return AppColors.mint;
      case PrismBadgeStatus.error:
        return AppColors.error;
      case PrismBadgeStatus.info:
        return AppColors.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border.all(color: _color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.dataLabel.copyWith(color: _color),
      ),
    );
  }
}
