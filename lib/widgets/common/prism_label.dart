import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// PRISM's shared section label with the rule-extending-right treatment,
/// already used in Admin. COPIED unmodified from prism_appbloc's
/// widgets/common/prism_label.dart.
class PrismLabel extends StatelessWidget {
  final String text;
  const PrismLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text.toUpperCase(), style: AppTextStyles.dataLabel),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: AppColors.border1)),
      ],
    );
  }
}
