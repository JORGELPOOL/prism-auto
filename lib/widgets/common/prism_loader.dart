import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// PRISM's shared loading indicator. COPIED unmodified from prism_appbloc's
/// widgets/common/prism_loader.dart.
class PrismLoader extends StatelessWidget {
  final double size;
  const PrismLoader({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.cyan),
    );
  }
}
