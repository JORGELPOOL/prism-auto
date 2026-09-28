import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// PRISM's shared card. COPIED unmodified from prism_appbloc's
/// widgets/common/prism_card.dart — bgVoid fill, zero radius, subtle 1px
/// border, generous padding.
class PrismCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  const PrismCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: color ?? AppColors.bgVoid,
        border: Border.all(color: borderColor ?? AppColors.border1, width: 1),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(color: Colors.transparent, child: InkWell(onTap: onTap, child: card));
  }
}
