import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/mock/auto_mock_data.dart';
import 'editor_event.dart';
import 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(const EditorLoading()) {
    on<LoadClip>(_onLoad);
    on<TrimChanged>(_onTrim);
    on<CaptionStyleChanged>(_onCaptionStyle);
    on<ColorPresetChanged>(_onColorPreset);
    on<SaveRequested>(_onSave);
  }

  Future<void> _onLoad(LoadClip event, Emitter<EditorState> emit) async {
    final clip = AutoMockData.allClips.firstWhere(
      (c) => c.id == event.clipId,
      orElse: () => AutoMockData.allClips.first,
    );
    emit(EditorEditing(clip));
  }

  void _onTrim(TrimChanged event, Emitter<EditorState> emit) {
    final current = state;
    if (current is! EditorEditing) return;
    emit(EditorEditing(
      current.clip.copyWith(trimStartSeconds: event.startSeconds, trimEndSeconds: event.endSeconds),
      dirty: true,
    ));
  }

  void _onCaptionStyle(CaptionStyleChanged event, Emitter<EditorState> emit) {
    final current = state;
    if (current is! EditorEditing) return;
    emit(EditorEditing(current.clip.copyWith(captionStyleIndex: event.styleIndex), dirty: true));
  }

  void _onColorPreset(ColorPresetChanged event, Emitter<EditorState> emit) {
    final current = state;
    if (current is! EditorEditing) return;
    emit(EditorEditing(current.clip.copyWith(colorPresetIndex: event.presetIndex), dirty: true));
  }

  Future<void> _onSave(SaveRequested event, Emitter<EditorState> emit) async {
    final current = state;
    if (current is! EditorEditing) return;
    emit(EditorSaving(current.clip));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(EditorSaved(current.clip));
    emit(EditorEditing(current.clip));
  }
}
