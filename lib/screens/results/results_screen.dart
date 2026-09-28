import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/results/results_bloc.dart';
import '../../blocs/results/results_event.dart';
import '../../blocs/results/results_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../repositories/auto_repository.dart';
import '../../widgets/auto/clip_card.dart';
import '../../widgets/common/prism_button.dart';
import '../../widgets/common/prism_loader.dart';
import '../editor/clip_editor_screen.dart';
import '../posts/captions_posts_screen.dart';

/// SCREEN 3: Results — Clip Gallery. The payoff, and PRISM AUTO's one
/// deliberate hero moment: the spectrum gradient rule under the heading,
/// used once per results load per Section 2 / 3.
class ResultsScreen extends StatelessWidget {
  final String uploadId;
  const ResultsScreen({super.key, required this.uploadId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResultsBloc(context.read<AutoRepository>())..add(LoadResults(uploadId)),
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: const _ResultsView(),
      ),
    );
  }
}

class _ResultsView extends StatefulWidget {
  const _ResultsView();

  @override
  State<_ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<_ResultsView> {
  bool _showPosts = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your clips are ready', style: AppTextStyles.pageTitle),
          const SizedBox(height: 8),
          Container(height: 2, width: 120, decoration: const BoxDecoration(gradient: AppColors.spectrumGradient)),
          const SizedBox(height: 24),
          Row(
            children: [
              _tab('Clips', !_showPosts, () => setState(() => _showPosts = false)),
              const SizedBox(width: 24),
              _tab('Captions & Posts', _showPosts, () => setState(() => _showPosts = true)),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<ResultsBloc, ResultsState>(
              builder: (context, state) {
                if (state is ResultsLoading) return const Center(child: PrismLoader());
                if (state is ResultsError) {
                  return Center(child: Text(state.message, style: AppTextStyles.bodyM.copyWith(color: AppColors.error)));
                }
                final loaded = state as ResultsLoaded;
                return _showPosts ? CaptionsPostsSection(posts: loaded.posts) : _clipGrid(context, loaded);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.navItem.copyWith(color: active ? AppColors.cyan : AppColors.textSilver)),
          const SizedBox(height: 6),
          Container(height: 2, width: 70, color: active ? AppColors.cyan : Colors.transparent),
        ],
      ),
    );
  }

  Widget _clipGrid(BuildContext context, ResultsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.selectedClipIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                PrismButton(label: 'Download Selected', onPressed: () {}, variant: PrismButtonVariant.ghost),
                const SizedBox(width: 12),
                PrismButton(
                  label: 'Delete Selected',
                  onPressed: () => context.read<ResultsBloc>().add(DeleteClips(state.selectedClipIds.toList())),
                  variant: PrismButtonVariant.ghost,
                ),
              ],
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 560 ? 2 : 1);
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.62,
                ),
                itemCount: state.clips.length,
                itemBuilder: (context, i) {
                  final clip = state.clips[i];
                  final selected = state.selectedClipIds.contains(clip.id);
                  return ClipCard(
                    clip: clip,
                    selected: selected,
                    onSelectChanged: (_) => context.read<ResultsBloc>().add(ToggleClipSelection(clip.id)),
                    onDownload: () {},
                    onEdit: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ClipEditorScreen(clipId: clip.id),
                    )),
                    onShare: () {},
                    onRetry: () => context.read<ResultsBloc>().add(RetryClip(clip.id)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
