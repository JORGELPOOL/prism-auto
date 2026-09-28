import 'package:equatable/equatable.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();
  @override
  List<Object?> get props => [];
}

class LoadClip extends EditorEvent {
  final String clipId;
  const LoadClip(this.clipId);
  @override
  List<Object?> get props => [clipId];
}

class TrimChanged extends EditorEvent {
  final int startSeconds;
  final int endSeconds;
  const TrimChanged(this.startSeconds, this.endSeconds);
  @override
  List<Object?> get props => [startSeconds, endSeconds];
}

class CaptionStyleChanged extends EditorEvent {
  final int styleIndex;
  const CaptionStyleChanged(this.styleIndex);
  @override
  List<Object?> get props => [styleIndex];
}

class ColorPresetChanged extends EditorEvent {
  final int presetIndex;
  const ColorPresetChanged(this.presetIndex);
  @override
  List<Object?> get props => [presetIndex];
}

class SaveRequested extends EditorEvent {
  const SaveRequested();
}
