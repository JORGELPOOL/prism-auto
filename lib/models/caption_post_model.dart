enum PostPlatform { instagram, linkedin, twitter }

enum PostTone { professional, casual, bold }

class CaptionPostModel {
  final String id;
  final String uploadId;
  final String? linkedClipId;
  final PostPlatform platform;
  final String text;
  final int? characterLimit;
  final PostTone tone;

  const CaptionPostModel({
    required this.id,
    required this.uploadId,
    this.linkedClipId,
    required this.platform,
    required this.text,
    this.characterLimit,
    this.tone = PostTone.professional,
  });

  CaptionPostModel copyWith({String? text, PostTone? tone}) {
    return CaptionPostModel(
      id: id,
      uploadId: uploadId,
      linkedClipId: linkedClipId,
      platform: platform,
      text: text ?? this.text,
      characterLimit: characterLimit,
      tone: tone ?? this.tone,
    );
  }
}
