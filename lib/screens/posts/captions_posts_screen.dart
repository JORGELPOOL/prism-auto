import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/results/results_bloc.dart';
import '../../blocs/results/results_event.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/caption_post_model.dart';
import '../../widgets/auto/post_draft_card.dart';
import '../../widgets/common/prism_label.dart';

/// SCREEN 5: Captions & Posts. Rendered in two ways:
///  - as CaptionsPostsSection, embedded in place inside Results (Screen 3)'s
///    "Captions & Posts" tab, reusing ResultsBloc's already-loaded data —
///    no separate bloc, no navigation, per the build spec.
///  - as CaptionsPostsScreen, a standalone Scaffold wrapper, for direct
///    navigation/testing.
class CaptionsPostsSection extends StatelessWidget {
  final List<CaptionPostModel> posts;
  final bool showTonePresets;

  const CaptionsPostsSection({super.key, required this.posts, this.showTonePresets = false});

  static const _labels = {
    PostPlatform.instagram: 'Instagram Captions',
    PostPlatform.linkedin: 'LinkedIn Post',
    PostPlatform.twitter: 'Tweets',
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final platform in PostPlatform.values) ...[
          PrismLabel(text: _labels[platform]!),
          const SizedBox(height: 16),
          if (showTonePresets) ...[
            Row(
              children: [
                for (final tone in const ['Professional', 'Casual', 'Bold'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: AppColors.bgSurface,
                      child: Text(tone.toUpperCase(), style: AppTextStyles.dataLabel),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          for (final post in posts.where((p) => p.platform == platform)) ...[
            PostDraftCard(
              post: post,
              onChanged: (_) {},
              onRegenerate: () => context.read<ResultsBloc>().add(RegeneratePost(post.id)),
              onCopy: () {},
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class CaptionsPostsScreen extends StatelessWidget {
  final List<CaptionPostModel> posts;
  const CaptionsPostsScreen({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: CaptionsPostsSection(posts: posts),
      ),
    );
  }
}
