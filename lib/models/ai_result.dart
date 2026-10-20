import 'detected_risk.dart';

class AIResult {
  final String riskLevel;
  final String riskTitle;
  final String riskDesc;
  final String recommendation;
  final int confidence;
  final List<DetectedRisk> risks;
  final String description;

  AIResult({
    required this.riskLevel,
    required this.riskTitle,
    required this.riskDesc,
    required this.recommendation,
    required this.confidence,
    required this.risks,
    required this.description,
  });
}