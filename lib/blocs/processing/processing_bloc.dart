import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/processing_status_model.dart';
import '../../repositories/auto_repository.dart';
import 'processing_event.dart';
import 'processing_state.dart';

/// Drives Screen 2 against the real GET /beam/uploads/:id/status
/// endpoint, polled every ~4s by AutoRepository.pollProcessingStatus
/// until the backend reports completed or failed. This bloc is provided
/// once, app-wide, in app.dart (not per-screen) so it keeps polling and
/// the shell's persistent Cyan-dot indicator stays live even after the
/// user navigates away from the Processing screen itself.
///
/// The backend has no ETA field, so etaSeconds below is a rough,
/// client-side estimate per step — not authoritative. "delayed" is true
/// once a single poll has been running for over 3 minutes of wall-clock
/// time, matching the spec's ">3x expected" warning trigger.
class ProcessingBloc extends Bloc<ProcessingEvent, ProcessingState> {
  final AutoRepository repository;
  DateTime? _pollStartedAt;

  ProcessingBloc(this.repository) : super(const ProcessingIdle()) {
    on<StartPolling>(_onStartPolling);
  }

  Future<void> _onStartPolling(StartPolling event, Emitter<ProcessingState> emit) async {
    _pollStartedAt = DateTime.now();
    try {
      await emit.forEach<ProcessingStatusResult>(
        repository.pollProcessingStatus(event.uploadId),
        onData: (result) {
          if (result.status == BackendUploadStatus.failed) {
            return ProcessingFailed(result.errorMessage ?? 'Processing failed.', uploadId: event.uploadId);
          }
          if (result.status == BackendUploadStatus.completed) {
            return ProcessingCompleted(event.uploadId);
          }
          final elapsed = DateTime.now().difference(_pollStartedAt!).inSeconds;
          return ProcessingInProgress(
            uploadId: event.uploadId,
            step: _stepFor(result.status),
            completedSteps: _completedStepsFor(result.status),
            etaSeconds: _etaFor(result.status),
            delayed: elapsed > 180,
          );
        },
      );
    } catch (e) {
      emit(ProcessingFailed(e.toString(), uploadId: event.uploadId));
    }
  }

  ProcessingStepName _stepFor(BackendUploadStatus status) {
    switch (status) {
      case BackendUploadStatus.queued:
      case BackendUploadStatus.transcribing:
        return ProcessingStepName.transcribing;
      case BackendUploadStatus.findingMoments:
        return ProcessingStepName.findingMoments;
      case BackendUploadStatus.cuttingClips:
        return ProcessingStepName.cuttingClips;
      case BackendUploadStatus.writingPosts:
      case BackendUploadStatus.completed:
      case BackendUploadStatus.failed:
        return ProcessingStepName.writingPosts;
    }
  }

  List<ProcessingStepName> _completedStepsFor(BackendUploadStatus status) {
    const order = [
      ProcessingStepName.transcribing,
      ProcessingStepName.findingMoments,
      ProcessingStepName.cuttingClips,
      ProcessingStepName.writingPosts,
    ];
    final int currentIndex = switch (status) {
      BackendUploadStatus.queued => -1,
      BackendUploadStatus.transcribing => -1,
      BackendUploadStatus.findingMoments => 0,
      BackendUploadStatus.cuttingClips => 1,
      BackendUploadStatus.writingPosts => 2,
      BackendUploadStatus.completed => 3,
      BackendUploadStatus.failed => -1,
    };
    return order.take(currentIndex + 1).toList();
  }

  int _etaFor(BackendUploadStatus status) {
    switch (status) {
      case BackendUploadStatus.queued:
        return 60;
      case BackendUploadStatus.transcribing:
        return 45;
      case BackendUploadStatus.findingMoments:
        return 30;
      case BackendUploadStatus.cuttingClips:
        return 15;
      case BackendUploadStatus.writingPosts:
        return 5;
      case BackendUploadStatus.completed:
      case BackendUploadStatus.failed:
        return 0;
    }
  }
}
