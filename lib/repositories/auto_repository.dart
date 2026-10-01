import 'dart:async';
import '../models/upload_model.dart';
import '../models/clip_model.dart';
import '../models/caption_post_model.dart';
import '../models/plan_model.dart';
import '../models/processing_status_model.dart';
import '../core/mock/auto_mock_data.dart';

/// UI-facing processing step, used by ProgressStepList (Screen 2). Kept
/// separate from BackendUploadStatus (the raw API enum) — the bloc maps
/// one to the other, since 'queued' has no visual step yet and
/// 'completed'/'failed' are handled as their own states, not steps.
enum ProcessingStepName { transcribing, findingMoments, cuttingClips, writingPosts }

/// Abstract data source for PRISM AUTO. Screen 2 (Processing) now calls
/// the real backend via fetchProcessingStatus/pollProcessingStatus
/// (Section 4 of the Final Master Spec v2, GET /beam/uploads/:id/status).
/// Every other method here is still mock-backed — they get wired to their
/// real endpoints one screen at a time, per the spec's own build order.
abstract class AutoRepository {
  Future<UploadModel> startUpload(String filename, int durationSeconds);
  Stream<double> uploadProgress();

  /// Real call: GET /beam/uploads/:id/status.
  Future<ProcessingStatusResult> fetchProcessingStatus(String uploadId);

  /// Polls [fetchProcessingStatus] every ~4s until the backend reports
  /// completed or failed. Shared by every implementation — only the
  /// single fetch above needs overriding.
  Stream<ProcessingStatusResult> pollProcessingStatus(String uploadId) async* {
    while (true) {
      final result = await fetchProcessingStatus(uploadId);
      yield result;
      if (result.status == BackendUploadStatus.completed || result.status == BackendUploadStatus.failed) {
        break;
      }
      await Future.delayed(const Duration(seconds: 4));
    }
  }

  Future<List<ClipModel>> getClips(String uploadId);
  Future<List<CaptionPostModel>> getPosts(String uploadId);
  Future<List<UploadModel>> getLibrary();
  Future<List<PlanModel>> getPlans();
  Future<CaptionPostModel> regeneratePost(String postId);
  Future<void> deleteClips(List<String> clipIds);
  Future<ClipModel> retryClip(String clipId);
  int minutesUsed();
  int minutesLimit();
}

/// Mock implementation — every method simulated in-memory. Still the
/// default for every screen except Processing (see LiveAutoRepository).
class MockAutoRepository implements AutoRepository {
  final Map<String, DateTime> _pollStart = {};

  @override
  Future<UploadModel> startUpload(String filename, int durationSeconds) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return UploadModel(
      id: 'up_${DateTime.now().millisecondsSinceEpoch}',
      filename: filename,
      durationSeconds: durationSeconds,
      uploadedAt: DateTime.now(),
      status: UploadStatus.processing,
      clipCount: 0,
    );
  }

  @override
  Stream<double> uploadProgress() async* {
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 90));
      yield i / 100;
    }
  }

  @override
  Future<ProcessingStatusResult> fetchProcessingStatus(String uploadId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final start = _pollStart.putIfAbsent(uploadId, () => DateTime.now());
    final elapsed = DateTime.now().difference(start).inSeconds;
    if (elapsed < 2) return const ProcessingStatusResult(status: BackendUploadStatus.queued);
    if (elapsed < 6) return const ProcessingStatusResult(status: BackendUploadStatus.transcribing);
    if (elapsed < 10) return const ProcessingStatusResult(status: BackendUploadStatus.findingMoments);
    if (elapsed < 14) return const ProcessingStatusResult(status: BackendUploadStatus.cuttingClips);
    if (elapsed < 18) return const ProcessingStatusResult(status: BackendUploadStatus.writingPosts);
    return const ProcessingStatusResult(status: BackendUploadStatus.completed);
  }

  @override
  Stream<ProcessingStatusResult> pollProcessingStatus(String uploadId) async* {
    while (true) {
      final result = await fetchProcessingStatus(uploadId);
      yield result;
      if (result.status == BackendUploadStatus.completed || result.status == BackendUploadStatus.failed) {
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Future<List<ClipModel>> getClips(String uploadId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AutoMockData.clipsFor(uploadId);
  }

  @override
  Future<List<CaptionPostModel>> getPosts(String uploadId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AutoMockData.postsFor(uploadId);
  }

  @override
  Future<List<UploadModel>> getLibrary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AutoMockData.library;
  }

  @override
  Future<List<PlanModel>> getPlans() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return AutoMockData.plans;
  }

  @override
  Future<CaptionPostModel> regeneratePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final existing = AutoMockData.allPosts.firstWhere((p) => p.id == postId);
    return existing.copyWith(text: '${existing.text} (regenerated)');
  }

  @override
  Future<void> deleteClips(List<String> clipIds) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<ClipModel> retryClip(String clipId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final existing = AutoMockData.allClips.firstWhere((c) => c.id == clipId);
    return existing.copyWith(status: ClipStatus.ready);
  }

  @override
  int minutesUsed() => AutoMockData.minutesUsed;

  @override
  int minutesLimit() => AutoMockData.minutesLimit;
}
