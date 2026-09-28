import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/editor/editor_bloc.dart';
import '../../blocs/editor/editor_event.dart';
import '../../blocs/editor/editor_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/auto/color_grade_panel.dart';
import '../../widgets/auto/trim_slider.dart';
import '../../widgets/common/prism_button.dart';
import '../../widgets/common/prism_loader.dart';
import '../export/export_screen.dart';

/// SCREEN 4: Clip Editor. Lightweight in-browser editing — trim, captions,
/// color. Not a full timeline editor.
class ClipEditorScreen extends StatelessWidget {
  final String clipId;
  const ClipEditorScreen({super.key, required this.clipId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditorBloc()..add(LoadClip(clipId)),
      child: const _EditorView(),
    );
  }
}

class _EditorView extends StatefulWidget {
  const _EditorView();

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView> {
  int _tabIndex = 0;
  static const _tabs = ['Trim', 'Captions', 'Color'];
  static const _captionStyles = ['Bold Center', 'Minimal Bottom', 'Karaoke', 'Boxed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocBuilder<EditorBloc, EditorState>(
        builder: (context, state) {
          if (state is EditorLoading) return const Center(child: PrismLoader());
          if (state is EditorError) {
            return Center(child: Text(state.message, style: AppTextStyles.bodyM.copyWith(color: AppColors.error)));
          }

          final clip = state is EditorEditing
              ? state.clip
              : state is EditorSaving
                  ? state.clip
                  : (state as EditorSaved).clip;
          final saving = state is EditorSaving;
          final dirty = state is EditorEditing && state.dirty;

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: AppColors.textSilver),
                      ),
                      Text(saving ? 'SAVING…' : (dirty ? 'UNSAVED' : 'SAVED'), style: AppTextStyles.dataLabel),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 800;
                      final preview = AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Container(color: AppColors.bgVoid),
                      );
                      final panel = Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                for (int i = 0; i < _tabs.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: InkWell(
                                      onTap: () => setState(() => _tabIndex = i),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _tabs[i],
                                            style: AppTextStyles.navItem
                                                .copyWith(color: _tabIndex == i ? AppColors.cyan : AppColors.textSilver),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(height: 2, width: 50, color: _tabIndex == i ? AppColors.cyan : Colors.transparent),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (_tabIndex == 0)
                              TrimSlider(
                                totalSeconds: clip.durationSeconds,
                                startSeconds: clip.trimStartSeconds,
                                endSeconds: clip.trimEndSeconds,
                                onChanged: (v) =>
                                    context.read<EditorBloc>().add(TrimChanged(v.start.round(), v.end.round())),
                              ),
                            if (_tabIndex == 1)
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  for (int i = 0; i < _captionStyles.length; i++)
                                    GestureDetector(
                                      onTap: () => context.read<EditorBloc>().add(CaptionStyleChanged(i)),
                                      child: Container(
                                        width: 96,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: AppColors.bgSurface,
                                          border: Border.all(
                                            color: clip.captionStyleIndex == i ? AppColors.cyan : AppColors.border1,
                                            width: clip.captionStyleIndex == i ? 2 : 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(_captionStyles[i], style: AppTextStyles.bodyS, textAlign: TextAlign.center),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            if (_tabIndex == 2)
                              ColorGradePanel(
                                selectedPreset: clip.colorPresetIndex,
                                onPresetSelected: (i) => context.read<EditorBloc>().add(ColorPresetChanged(i)),
                              ),
                          ],
                        ),
                      );

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(flex: 6, child: Center(child: preview)),
                            Expanded(flex: 5, child: SingleChildScrollView(child: panel)),
                          ],
                        );
                      }
                      return SingleChildScrollView(child: Column(children: [preview, panel]));
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white12))),
                  child: Row(
                    children: [
                      PrismButton(label: 'Discard', onPressed: () => Navigator.of(context).pop(), variant: PrismButtonVariant.ghost),
                      const SizedBox(width: 12),
                      PrismButton(
                        label: 'Save Changes',
                        onPressed: () => context.read<EditorBloc>().add(const SaveRequested()),
                        variant: PrismButtonVariant.ghost,
                        loading: saving,
                      ),
                      const Spacer(),
                      PrismButton(
                        label: 'Export',
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ExportScreen())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
