/// Mirrors GET /beam/uploads/:id/status's raw `status` field exactly
/// (Section 4 of the Final Master Spec v2): queued, transcribing,
/// finding_moments, cutting_clips, writing_posts, completed, failed.
enum BackendUploadStatus {
  queued,
  transcribing,
  findingMoments,
  cuttingClips,
  writingPosts,
  completed,
  failed,
}

class ProcessingStatusResult {
  final BackendUploadStatus status;
  final String? errorMessage;

  const ProcessingStatusResult({required this.status, this.errorMessage});

  factory ProcessingStatusResult.fromJson(Map<String, dynamic> json) {
    return ProcessingStatusResult(
      status: _parseStatus(json['status'] as String? ?? 'queued'),
      errorMessage: json['error_message'] as String?,
    );
  }

  static BackendUploadStatus _parseStatus(String raw) {
    switch (raw) {
      case 'queued':
        return BackendUploadStatus.queued;
      case 'transcribing':
        return BackendUploadStatus.transcribing;
      case 'finding_moments':
        return BackendUploadStatus.findingMoments;
      case 'cutting_clips':
        return BackendUploadStatus.cuttingClips;
      case 'writing_posts':
        return BackendUploadStatus.writingPosts;
      case 'completed':
        return BackendUploadStatus.completed;
      case 'failed':
        return BackendUploadStatus.failed;
      default:
        return BackendUploadStatus.queued;
    }
  }
}
