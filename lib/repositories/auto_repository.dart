import 'dart:async';
import '../models/upload_model.dart';
import '../models/clip_model.dart';
import '../models/caption_post_model.dart';
import '../models/plan_model.dart';
import '../core/mock/auto_mock_data.dart';

enum ProcessingStepName { transcribing, findingMoments, cuttingClips, writingPosts }

class ProcessingStep {
  final ProcessingStepName step;
  final bool complete;
  final int etaSeconds;
  const ProcessingStep({required this.step, required this.complete, required this.etaSeconds});
}

/// Abstract data source for PRISM AUTO. A real implementation will call
/// the API contract issued separately after these screens are reviewed.
abstract class AutoRepository {
  Future<UploadModel> startUpload(String filename, int durationSeconds);
  Stream<double> uploadProgress();
  Stream<ProcessingStep> processingSteps(String uploadId);
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

/// Mock implementation — simulated latency, in-memory data from
/// AutoMockData. This is what every screen builds against this pass.
class MockAutoRepository implements AutoRepository {
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
  Stream<ProcessingStep> processingSteps(String uploadId) async* {
    final steps = ProcessingStepName.values;
    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 900));
      yield ProcessingStep(
        step: steps[i],
        complete: true,
        etaSeconds: (steps.length - i - 1) * 3,
      );
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
