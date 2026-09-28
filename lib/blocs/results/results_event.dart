import 'package:equatable/equatable.dart';
import '../../models/caption_post_model.dart';

abstract class ResultsEvent extends Equatable {
  const ResultsEvent();
  @override
  List<Object?> get props => [];
}

class LoadResults extends ResultsEvent {
  final String uploadId;
  const LoadResults(this.uploadId);
  @override
  List<Object?> get props => [uploadId];
}

class RetryClip extends ResultsEvent {
  final String clipId;
  const RetryClip(this.clipId);
  @override
  List<Object?> get props => [clipId];
}

class DeleteClips extends ResultsEvent {
  final List<String> clipIds;
  const DeleteClips(this.clipIds);
  @override
  List<Object?> get props => [clipIds];
}

class ToggleClipSelection extends ResultsEvent {
  final String clipId;
  const ToggleClipSelection(this.clipId);
  @override
  List<Object?> get props => [clipId];
}

class RegeneratePost extends ResultsEvent {
  final String postId;
  const RegeneratePost(this.postId);
  @override
  List<Object?> get props => [postId];
}

class ChangePostTone extends ResultsEvent {
  final String postId;
  final PostTone tone;
  const ChangePostTone(this.postId, this.tone);
  @override
  List<Object?> get props => [postId, tone];
}
