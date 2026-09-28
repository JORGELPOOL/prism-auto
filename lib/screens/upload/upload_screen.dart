import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/upload/upload_bloc.dart';
import '../../blocs/upload/upload_event.dart';
import '../../blocs/upload/upload_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../repositories/auto_repository.dart';
import '../../widgets/common/dashed_border.dart';
import '../../widgets/common/prism_button.dart';
import '../../widgets/common/prism_card.dart';
import '../processing/processing_screen.dart';

/// SCREEN 1: Upload. First screen after login — the entire value
/// proposition in one screen.
class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadBloc(context.read<AutoRepository>()),
      child: const _UploadView(),
    );
  }
}

class _UploadView extends StatefulWidget {
  const _UploadView();

  @override
  State<_UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<_UploadView> {
  bool _linkTab = false;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AutoRepository>();
    final used = repo.minutesUsed();
    final limit = repo.minutesLimit();

    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadDone) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProcessingScreen(uploadId: state.uploadId),
          ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upload', style: AppTextStyles.pageTitle),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: AppColors.bgSurface,
                  child: Text('$used / $limit MIN LEFT THIS MONTH', style: AppTextStyles.dataTag),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGapSmall),
            Row(
              children: [
                _GhostTab(label: 'Upload File', active: !_linkTab, onTap: () => setState(() => _linkTab = false)),
                const SizedBox(width: 24),
                _GhostTab(label: 'Paste a Link', active: _linkTab, onTap: () => setState(() => _linkTab = true)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: SingleChildScrollView(
                    child: BlocBuilder<UploadBloc, UploadState>(
                      builder: (context, state) => _buildBody(context, state),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, UploadState state) {
    if (state is UploadError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dropZone(context),
          const SizedBox(height: 16),
          Text(state.message, style: AppTextStyles.bodyM.copyWith(color: AppColors.error), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          PrismButton(label: 'View Plans', onPressed: () {}, variant: PrismButtonVariant.ghost),
        ],
      );
    }
    if (state is UploadFilePicked) {
      return PrismCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 120, color: AppColors.bgSurface),
            const SizedBox(height: 16),
            Text(state.filename, style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite)),
            const SizedBox(height: 4),
            Text('${(state.durationSeconds / 60).round()} min', style: AppTextStyles.dataTag),
            const SizedBox(height: 20),
            PrismButton(
              label: 'Start Processing',
              onPressed: () => context.read<UploadBloc>().add(const UploadStarted()),
              fullWidth: true,
            ),
          ],
        ),
      );
    }
    if (state is UploadUploading) {
      return PrismCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.filename, style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite)),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: state.progress, color: AppColors.cyan, backgroundColor: AppColors.bgSurface),
            const SizedBox(height: 8),
            Text('${(state.progress * 100).round()}%', style: AppTextStyles.dataLabel),
          ],
        ),
      );
    }
    return _dropZone(context);
  }

  Widget _dropZone(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_linkTab) {
          context.read<UploadBloc>().add(const LinkPasted('https://example.com/video'));
        } else {
          context.read<UploadBloc>().add(const FileSelected('podcast_ep_43_raw.mp4', 2640));
        }
      },
      child: DashedBorderBox(
        color: AppColors.border3,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(56),
          color: AppColors.bgVoid,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.upload_file, size: 32, color: AppColors.cyan),
              const SizedBox(height: 16),
              Text(
                _linkTab ? 'Paste a link to your video' : 'Drop your video, or click to browse',
                style: AppTextStyles.sectionHead,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text('MP4 OR MOV · UP TO ${context.read<AutoRepository>().minutesLimit()} MIN', style: AppTextStyles.dataLabel),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _GhostTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.navItem.copyWith(color: active ? AppColors.cyan : AppColors.textSilver)),
          const SizedBox(height: 6),
          Container(height: 2, width: 90, color: active ? AppColors.cyan : Colors.transparent),
        ],
      ),
    );
  }
}
