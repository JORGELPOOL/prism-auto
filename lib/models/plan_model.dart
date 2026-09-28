class PlanModel {
  final String id;
  final String name;
  final int priceMonthly;
  final int sourceMinutes;
  final int clipsPerUpload; // -1 means unlimited
  final String captionStyles;
  final String colorGrading;
  final String postCopy;
  final String exportQuality;
  final int seats;
  final bool isPopular;
  final bool isCurrent;

  const PlanModel({
    required this.id,
    required this.name,
    required this.priceMonthly,
    required this.sourceMinutes,
    required this.clipsPerUpload,
    required this.captionStyles,
    required this.colorGrading,
    required this.postCopy,
    required this.exportQuality,
    required this.seats,
    this.isPopular = false,
    this.isCurrent = false,
  });
}
