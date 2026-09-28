import 'package:equatable/equatable.dart';
import '../../models/clip_model.dart';
import '../../models/caption_post_model.dart';

abstract class ResultsState extends Equatable {
  const ResultsState();
  @override
  List<Object?> get props => [];
}

class ResultsLoading extends ResultsState {
  const ResultsLoading();
}

class ResultsLoaded extends ResultsState {
  final List<ClipModel> clips;
  final List<CaptionPostModel> posts;
  final Set<String> selectedClipIds;

  const ResultsLoaded({
    required this.clips,
    required this.posts,
    this.selectedClipIds = const {},
  });

  ResultsLoaded copyWith({
    List<ClipModel>? clips,
    List<CaptionPostModel>? posts,
    Set<String>? selectedClipIds,
  }) {
    return ResultsLoaded(
      clips: clips ?? this.clips,
      posts: posts ?? this.posts,
      selectedClipIds: selectedClipIds ?? this.selectedClipIds,
    );
  }

  @override
  List<Object?> get props => [clips, posts, selectedClipIds];
}

class ResultsError extends ResultsState {
  final String message;
  const ResultsError(this.message);
  @override
  List<Object?> get props => [message];
}
