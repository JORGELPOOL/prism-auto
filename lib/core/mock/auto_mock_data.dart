import '../../models/upload_model.dart';
import '../../models/clip_model.dart';
import '../../models/caption_post_model.dart';
import '../../models/plan_model.dart';

/// Mock data for PRISM AUTO, same pattern as MockAdminRepository /
/// MockClientRepository in prism_appbloc. Screens build against this
/// until a separate API contract is issued.
class AutoMockData {
  AutoMockData._();

  static const int minutesUsed = 214;
  static const int minutesLimit = 500;

  static final List<UploadModel> library = [
    UploadModel(
      id: 'up_1',
      filename: 'podcast_ep_42_raw.mp4',
      durationSeconds: 3420,
      uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: UploadStatus.ready,
      clipCount: 5,
    ),
    UploadModel(
      id: 'up_2',
      filename: 'keynote_talk_final.mov',
      durationSeconds: 2760,
      uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
      status: UploadStatus.ready,
      clipCount: 6,
    ),
    UploadModel(
      id: 'up_3',
      filename: 'interview_founder_series.mp4',
      durationSeconds: 1980,
      uploadedAt: DateTime.now().subtract(const Duration(hours: 4)),
      status: UploadStatus.processing,
      clipCount: 0,
    ),
  ];

  static final List<ClipModel> allClips = [
    ClipModel(id: 'clip_1', uploadId: 'up_1', hookText: 'The mistake every founder makes in year one', durationSeconds: 42),
    ClipModel(id: 'clip_2', uploadId: 'up_1', hookText: 'Why we almost shut down after 6 months', durationSeconds: 58),
    ClipModel(id: 'clip_3', uploadId: 'up_1', hookText: 'This one metric changed everything', durationSeconds: 35),
    ClipModel(id: 'clip_4', uploadId: 'up_1', hookText: 'Nobody tells you this about fundraising', durationSeconds: 61, status: ClipStatus.failed),
    ClipModel(id: 'clip_5', uploadId: 'up_1', hookText: 'The hardest conversation with my co-founder', durationSeconds: 49),
  ];

  /// Falls back to the full demo set so any uploadId (including a
  /// freshly-created mock upload) still lands on a populated gallery.
  static List<ClipModel> clipsFor(String uploadId) {
    final matches = allClips.where((c) => c.uploadId == uploadId).toList();
    return matches.isNotEmpty ? matches : allClips;
  }

  static final List<CaptionPostModel> allPosts = [
    CaptionPostModel(
      id: 'post_1',
      uploadId: 'up_1',
      linkedClipId: 'clip_1',
      platform: PostPlatform.instagram,
      text: 'The mistake every founder makes in year one (and how we fixed it before it sank us).',
      characterLimit: 2200,
    ),
    CaptionPostModel(
      id: 'post_2',
      uploadId: 'up_1',
      linkedClipId: 'clip_2',
      platform: PostPlatform.linkedin,
      text: 'We almost shut down at month six. Here is the one decision that turned it around, and what I would tell any founder hitting the same wall.',
      characterLimit: 3000,
    ),
    CaptionPostModel(
      id: 'post_3',
      uploadId: 'up_1',
      linkedClipId: 'clip_3',
      platform: PostPlatform.twitter,
      text: 'This one metric changed everything for us. A thread on what we tracked wrong for a year.',
      characterLimit: 280,
    ),
  ];

  static List<CaptionPostModel> postsFor(String uploadId) {
    final matches = allPosts.where((p) => p.uploadId == uploadId).toList();
    return matches.isNotEmpty ? matches : allPosts;
  }

  static final List<PlanModel> plans = [
    PlanModel(
      id: 'starter',
      name: 'Starter',
      priceMonthly: 25,
      sourceMinutes: 150,
      clipsPerUpload: 5,
      captionStyles: '1 style',
      colorGrading: '—',
      postCopy: '—',
      exportQuality: '720p, watermark',
      seats: 1,
    ),
    PlanModel(
      id: 'creator',
      name: 'Creator',
      priceMonthly: 79,
      sourceMinutes: 500,
      clipsPerUpload: 12,
      captionStyles: 'All styles',
      colorGrading: '6 presets',
      postCopy: 'Yes',
      exportQuality: '1080p, no watermark',
      seats: 1,
      isPopular: true,
      isCurrent: true,
    ),
    PlanModel(
      id: 'studio',
      name: 'Studio',
      priceMonthly: 149,
      sourceMinutes: 1500,
      clipsPerUpload: -1,
      captionStyles: 'All + custom fonts',
      colorGrading: '6 presets + manual',
      postCopy: 'Yes + tone presets',
      exportQuality: '4K, no watermark',
      seats: 3,
    ),
  ];
}
