import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auto_repository.dart';
import 'results_event.dart';
import 'results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  final AutoRepository repository;

  ResultsBloc(this.repository) : super(const ResultsLoading()) {
    on<LoadResults>(_onLoad);
    on<RetryClip>(_onRetry);
    on<DeleteClips>(_onDelete);
    on<ToggleClipSelection>(_onToggleSelection);
    on<RegeneratePost>(_onRegenerate);
    on<ChangePostTone>(_onToneChange);
  }

  Future<void> _onLoad(LoadResults event, Emitter<ResultsState> emit) async {
    emit(const ResultsLoading());
    try {
      final clips = await repository.getClips(event.uploadId);
      final posts = await repository.getPosts(event.uploadId);
      emit(ResultsLoaded(clips: clips, posts: posts));
    } catch (e) {
      emit(ResultsError(e.toString()));
    }
  }

  Future<void> _onRetry(RetryClip event, Emitter<ResultsState> emit) async {
    final current = state;
    if (current is! ResultsLoaded) return;
    try {
      final updated = await repository.retryClip(event.clipId);
      final newClips = current.clips.map((c) => c.id == updated.id ? updated : c).toList();
      emit(current.copyWith(clips: newClips));
    } catch (e) {
      emit(ResultsError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteClips event, Emitter<ResultsState> emit) async {
    final current = state;
    if (current is! ResultsLoaded) return;
    await repository.deleteClips(event.clipIds);
    final newClips = current.clips.where((c) => !event.clipIds.contains(c.id)).toList();
    emit(current.copyWith(clips: newClips, selectedClipIds: {}));
  }

  void _onToggleSelection(ToggleClipSelection event, Emitter<ResultsState> emit) {
    final current = state;
    if (current is! ResultsLoaded) return;
    final newSet = Set<String>.from(current.selectedClipIds);
    if (!newSet.remove(event.clipId)) {
      newSet.add(event.clipId);
    }
    emit(current.copyWith(selectedClipIds: newSet));
  }

  Future<void> _onRegenerate(RegeneratePost event, Emitter<ResultsState> emit) async {
    final current = state;
    if (current is! ResultsLoaded) return;
    final updated = await repository.regeneratePost(event.postId);
    final newPosts = current.posts.map((p) => p.id == updated.id ? updated : p).toList();
    emit(current.copyWith(posts: newPosts));
  }

  Future<void> _onToneChange(ChangePostTone event, Emitter<ResultsState> emit) async {
    final current = state;
    if (current is! ResultsLoaded) return;
    final newPosts = current.posts
        .map((p) => p.id == event.postId ? p.copyWith(tone: event.tone) : p)
        .toList();
    emit(current.copyWith(posts: newPosts));
  }
}
