import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'prism_card.dart';

/// PRISM's shared stat display. COPIED unmodified from prism_appbloc's
/// widgets/common/stat_card.dart.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const StatCard({super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return PrismCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.dataLabel),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.statMedium.copyWith(color: valueColor ?? AppColors.textWhite)),
        ],
      ),
    );
  }
}
