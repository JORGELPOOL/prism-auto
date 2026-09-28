import 'package:equatable/equatable.dart';
import '../../models/clip_model.dart';

abstract class EditorState extends Equatable {
  const EditorState();
  @override
  List<Object?> get props => [];
}

class EditorLoading extends EditorState {
  const EditorLoading();
}

class EditorEditing extends EditorState {
  final ClipModel clip;
  final bool dirty;
  const EditorEditing(this.clip, {this.dirty = false});
  @override
  List<Object?> get props => [clip, dirty];
}

class EditorSaving extends EditorState {
  final ClipModel clip;
  const EditorSaving(this.clip);
  @override
  List<Object?> get props => [clip];
}

class EditorSaved extends EditorState {
  final ClipModel clip;
  const EditorSaved(this.clip);
  @override
  List<Object?> get props => [clip];
}

class EditorError extends EditorState {
  final String message;
  const EditorError(this.message);
  @override
  List<Object?> get props => [message];
}
