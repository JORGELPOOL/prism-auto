import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/library/library_bloc.dart';
import '../../blocs/library/library_event.dart';
import '../../blocs/library/library_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/upload_model.dart';
import '../../repositories/auto_repository.dart';
import '../../widgets/common/prism_badge.dart';
import '../../widgets/common/prism_button.dart';
import '../../widgets/common/prism_card.dart';
import '../../widgets/common/prism_loader.dart';
import '../results/results_screen.dart';
import '../upload/upload_screen.dart';

/// SCREEN 7: Library. Home base for returning users; AutoShell lives here
/// (build order: Upload -> Processing -> Library -> Results -> ...).
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryBloc(context.read<AutoRepository>())..add(const LoadLibrary()),
      child: const _LibraryView(),
    );
  }
}

class _LibraryView extends StatelessWidget {
  const _LibraryView();

  void _openUpload(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Scaffold(body: UploadScreen())));
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AutoRepository>();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 12,
            children: [
              Text('Your Library', style: AppTextStyles.pageTitle),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: AppColors.bgSurface,
                    child: Text('${repo.minutesUsed()} / ${repo.minutesLimit()} MIN LEFT THIS MONTH', style: AppTextStyles.dataTag),
                  ),
                  const SizedBox(width: 16),
                  PrismButton(label: 'New Upload', onPressed: () => _openUpload(context)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGapSmall),
          Expanded(
            child: BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoading || state is LibraryInitial) {
                  return const Center(child: PrismLoader());
                }
                if (state is LibraryError) {
                  return Center(child: Text(state.message, style: AppTextStyles.bodyM.copyWith(color: AppColors.error)));
                }
                final uploads = (state as LibraryLoaded).uploads;
                if (uploads.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.video_library_outlined, size: 40, color: AppColors.textDim),
                        const SizedBox(height: 16),
                        Text('No uploads yet', style: AppTextStyles.sectionHead),
                        const SizedBox(height: 20),
                        PrismButton(label: 'Upload your first video', onPressed: () => _openUpload(context)),
                      ],
                    ),
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 560 ? 2 : 1);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: uploads.length,
                      itemBuilder: (context, i) {
                        final upload = uploads[i];
                        return PrismCard(
                          onTap: upload.status == UploadStatus.ready
                              ? () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) => ResultsScreen(uploadId: upload.id)))
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(height: 90, width: double.infinity, color: AppColors.bgSurface),
                              const SizedBox(height: 12),
                              Text(
                                upload.filename,
                                style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${upload.uploadedAt.month}/${upload.uploadedAt.day}', style: AppTextStyles.dataLabel),
                                  if (upload.status == UploadStatus.processing)
                                    const PrismBadge(label: 'Pending', status: PrismBadgeStatus.pending)
                                  else
                                    Text('${upload.clipCount} clips', style: AppTextStyles.dataTag),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
