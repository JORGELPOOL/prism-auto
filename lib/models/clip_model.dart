enum ClipStatus { ready, processing, failed }

class ClipModel {
  final String id;
  final String uploadId;
  final String hookText;
  final int durationSeconds;
  final ClipStatus status;
  final int trimStartSeconds;
  final int trimEndSeconds;
  final int captionStyleIndex;
  final int colorPresetIndex;

  ClipModel({
    required this.id,
    required this.uploadId,
    required this.hookText,
    required this.durationSeconds,
    this.status = ClipStatus.ready,
    this.trimStartSeconds = 0,
    int? trimEndSeconds,
    this.captionStyleIndex = 0,
    this.colorPresetIndex = 0,
  }) : trimEndSeconds = trimEndSeconds ?? durationSeconds;

  ClipModel copyWith({
    ClipStatus? status,
    int? trimStartSeconds,
    int? trimEndSeconds,
    int? captionStyleIndex,
    int? colorPresetIndex,
  }) {
    return ClipModel(
      id: id,
      uploadId: uploadId,
      hookText: hookText,
      durationSeconds: durationSeconds,
      status: status ?? this.status,
      trimStartSeconds: trimStartSeconds ?? this.trimStartSeconds,
      trimEndSeconds: trimEndSeconds ?? this.trimEndSeconds,
      captionStyleIndex: captionStyleIndex ?? this.captionStyleIndex,
      colorPresetIndex: colorPresetIndex ?? this.colorPresetIndex,
    );
  }
}
