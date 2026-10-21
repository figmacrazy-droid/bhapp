class DetectedRisk {
  final String name;
  final int confidence;
  final List<double> bbox;

  DetectedRisk({
    required this.name,
    required this.confidence,
    required this.bbox,
  });

  /// Normalizes a confidence value from the AI (may be 0-1, 0-100,
  /// a number or a string) to an int percentage 0-100.
  static int toPercent(dynamic value) {
    double v;
    if (value is num) {
      v = value.toDouble();
    } else {
      v = double.tryParse(value?.toString() ?? '') ?? 0;
    }
    if (v > 0 && v <= 1) v *= 100;
    return v.clamp(0, 100).round();
  }

  factory DetectedRisk.fromJson(Map<String, dynamic> json) {
    List<double> bbox = [0.3, 0.3, 0.7, 0.7];
    final raw = json['bbox'];
    if (raw is List && raw.length == 4) {
      final parsed = raw
          .map((e) => e is num ? e.toDouble() : double.tryParse('$e'))
          .toList();
      if (!parsed.contains(null)) {
        // Some models return pixel or 0-1000 coordinates; normalize to 0-1.
        var values = parsed.cast<double>();
        final maxV = values.reduce((a, b) => a > b ? a : b);
        if (maxV > 1) {
          final scale = maxV <= 100 ? 100.0 : 1000.0;
          values = values.map((v) => v / scale).toList();
        }
        bbox = values.map((v) => v.clamp(0.0, 1.0)).toList();
      }
    }
    return DetectedRisk(
      name: (json['name'] ?? '').toString(),
      confidence: toPercent(json['confidence']),
      bbox: bbox,
    );
  }
}
