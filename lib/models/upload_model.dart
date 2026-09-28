enum UploadStatus { pending, processing, ready, failed }

class UploadModel {
  final String id;
  final String filename;
  final int durationSeconds;
  final DateTime uploadedAt;
  final UploadStatus status;
  final int clipCount;

  const UploadModel({
    required this.id,
    required this.filename,
    required this.durationSeconds,
    required this.uploadedAt,
    required this.status,
    required this.clipCount,
  });

  UploadModel copyWith({UploadStatus? status, int? clipCount}) {
    return UploadModel(
      id: id,
      filename: filename,
      durationSeconds: durationSeconds,
      uploadedAt: uploadedAt,
      status: status ?? this.status,
      clipCount: clipCount ?? this.clipCount,
    );
  }
}
