import '../core/network/api_client.dart';
import '../models/processing_status_model.dart';
import 'auto_repository.dart';

/// Hybrid repository the app runs on right now: Screen 2 (Processing)
/// calls the real live backend from Section 4 of the Final Master Spec
/// v2 (GET /beam/uploads/:id/status), while every other screen still
/// falls back to MockAutoRepository's in-memory data. Wire up the next
/// screen by overriding its method here, per the spec's "one screen at a
/// time, review after each" build order — Screen 7 (Library) is next.
class LiveAutoRepository extends MockAutoRepository {
  final ApiClient _client;

  LiveAutoRepository({ApiClient? client}) : _client = client ?? ApiClient();

  @override
  Future<ProcessingStatusResult> fetchProcessingStatus(String uploadId) async {
    final json = await _client.get('/beam/uploads/$uploadId/status');
    return ProcessingStatusResult.fromJson(json as Map<String, dynamic>);
  }

  @override
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
}
