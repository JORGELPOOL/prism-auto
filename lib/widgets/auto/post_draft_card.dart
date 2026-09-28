import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/caption_post_model.dart';
import '../common/prism_card.dart';

/// Editable draft card for Captions & Posts (Screen 5).
class PostDraftCard extends StatelessWidget {
  final CaptionPostModel post;
  final ValueChanged<String> onChanged;
  final VoidCallback onRegenerate;
  final VoidCallback onCopy;

  const PostDraftCard({
    super.key,
    required this.post,
    required this.onChanged,
    required this.onRegenerate,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: post.text);
    return PrismCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (post.linkedClipId != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: AppColors.bgSurface,
              child: Text('CLIP #${post.linkedClipId}', style: AppTextStyles.dataLabel),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: controller,
            maxLines: null,
            onChanged: onChanged,
            style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (post.characterLimit != null)
                Text('${post.text.length} / ${post.characterLimit}', style: AppTextStyles.dataLabel)
              else
                const SizedBox.shrink(),
              Row(
                children: [
                  InkWell(
                    onTap: onRegenerate,
                    child: Row(
                      children: [
                        Icon(Icons.refresh, size: 14, color: AppColors.textSilver),
                        const SizedBox(width: 4),
                        Text('REGENERATE', style: AppTextStyles.dataLabel),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(onTap: onCopy, child: Icon(Icons.copy, size: 16, color: AppColors.textSilver)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
