import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/clip_model.dart';
import '../common/prism_card.dart';

class ClipCard extends StatelessWidget {
  final ClipModel clip;
  final bool selected;
  final ValueChanged<bool?> onSelectChanged;
  final VoidCallback onDownload;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onRetry;

  const ClipCard({
    super.key,
    required this.clip,
    required this.selected,
    required this.onSelectChanged,
    required this.onDownload,
    required this.onEdit,
    required this.onShare,
    required this.onRetry,
  });

  String get _duration {
    final m = clip.durationSeconds ~/ 60;
    final s = clip.durationSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (clip.status == ClipStatus.failed) {
      return PrismCard(
        padding: const EdgeInsets.all(16),
        color: AppColors.bgSurface,
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 24),
              const SizedBox(height: 8),
              Text("Couldn't generate this one",
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.error), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onRetry,
                child: Text('RETRY', style: AppTextStyles.dataLabel.copyWith(color: AppColors.cyan)),
              ),
            ],
          ),
        ),
      );
    }

    return PrismCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AspectRatio(aspectRatio: 9 / 16, child: Container(color: AppColors.bgSurface)),
              Positioned(
                top: 4,
                left: 4,
                child: Checkbox(
                  value: selected,
                  onChanged: onSelectChanged,
                  fillColor: MaterialStateProperty.all(AppColors.bgVoid),
                  checkColor: AppColors.cyan,
                  side: BorderSide(color: AppColors.border2),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  color: AppColors.bgVoid.withOpacity(0.85),
                  child: Text(_duration, style: AppTextStyles.dataTag),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clip.hookText,
                  style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _IconAction(icon: Icons.download_outlined, onTap: onDownload),
                    const SizedBox(width: 16),
                    _IconAction(icon: Icons.edit_outlined, onTap: onEdit),
                    const SizedBox(width: 16),
                    _IconAction(icon: Icons.ios_share, onTap: onShare),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: Icon(icon, size: 18, color: AppColors.textSilver));
  }
}
