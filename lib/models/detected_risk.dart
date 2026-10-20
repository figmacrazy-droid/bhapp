class DetectedRisk {
  final String name;
  final int confidence;
  final List<double> bbox;

  DetectedRisk({
    required this.name,
    required this.confidence,
    required this.bbox,
  });

  factory DetectedRisk.fromJson(Map<String, dynamic> json) {
    return DetectedRisk(
      name: json['name'] ?? '',
      confidence: (json['confidence'] ?? 0).toInt(),
      bbox: (json['bbox'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [0.3, 0.3, 0.7, 0.7],
    );
  }
}