import 'package:flutter/material.dart';
import 'dart:io';
import '../models/ai_result.dart';
import '../models/detected_risk.dart';
import '../services/pdf_service.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';

class ResultScreen extends StatelessWidget {
  final AIResult result;
  final File image;

  const ResultScreen({super.key, required this.result, required this.image});

  Color get _mainColor {
    switch (result.riskLevel) {
      case 'high':
        return const Color(0xFFE53935);
      case 'medium':
        return const Color(0xFFFB8C00);
      default:
        return const Color(0xFF43A047);
    }
  }

  String get _title {
    switch (result.riskLevel) {
      case 'high':
        return T.highRisk;
      case 'medium':
        return T.mediumRisk;
      default:
        return T.lowRisk;
    }
  }

  IconData get _icon {
    switch (result.riskLevel) {
      case 'high':
        return Icons.dangerous_rounded;
      case 'medium':
        return Icons.warning_amber_rounded;
      default:
        return Icons.verified_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = Responsive.screenHeight(context);
    final isSmall = sh < 700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              _mainColor.withOpacity(0.05),
              _mainColor.withOpacity(0.1)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Color(0xFF1A2B3C)),
                    ),
                    Text(T.result,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2B3C))),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: isSmall ? 16 : 22),
                    child: Column(
                      children: [
                        SizedBox(height: isSmall ? 10 : 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _mainColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                  color: _mainColor.withOpacity(0.35),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10))
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(image, fit: BoxFit.cover),
                                  if (result.risks.isNotEmpty)
                                    ...result.risks
                                        .map((risk) => _buildRiskBox(risk)),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.6),
                                            Colors.transparent
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _mainColor,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: _mainColor,
                                                    blurRadius: 8)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${result.risks.length} ${AppLanguage.isArabic ? "خطر" : "risks"}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: _mainColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: _mainColor.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6))
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_icon, color: Colors.white, size: 22),
                              const SizedBox(width: 8),
                              Text(_title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmall ? 15 : 17,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        if (result.confidence > 0) ...[
                          const SizedBox(height: 10),
                          Text('${T.confidence}: ${result.confidence}%',
                              style: TextStyle(
                                  color: _mainColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                        const SizedBox(height: 20),
                        if (result.description.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: _mainColor.withOpacity(0.15),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10))
                              ],
                              border: Border.all(
                                  color: _mainColor.withOpacity(0.3),
                                  width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.visibility_rounded,
                                        color: _mainColor, size: 22),
                                    const SizedBox(width: 8),
                                    Text(T.whatISee,
                                        style: TextStyle(
                                            color: _mainColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(result.description,
                                    style: TextStyle(
                                        fontSize: isSmall ? 13 : 14,
                                        color: const Color(0xFF1A2B3C),
                                        height: 1.7)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (result.risks.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: _mainColor.withOpacity(0.15),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.list_alt_rounded,
                                        color: _mainColor, size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                        AppLanguage.isArabic
                                            ? 'المخاطر المكتشفة'
                                            : 'Detected Risks',
                                        style: TextStyle(
                                            color: _mainColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...result.risks
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final idx = entry.key + 1;
                                  final risk = entry.value;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _mainColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: _mainColor.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _mainColor),
                                          child: Center(
                                            child: Text('$idx',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(risk.name,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1A2B3C))),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: _mainColor.withOpacity(0.15),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Text('${risk.confidence}%',
                                              style: TextStyle(
                                                  color: _mainColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: _mainColor.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.report_rounded,
                                      color: _mainColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text(T.detected,
                                      style: TextStyle(
                                          color: _mainColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(result.riskTitle,
                                  style: TextStyle(
                                      fontSize: isSmall ? 17 : 19,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A2B3C))),
                              const SizedBox(height: 16),
                              Divider(color: _mainColor.withOpacity(0.2)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.lightbulb_rounded,
                                      color: _mainColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text(T.recommendation,
                                      style: TextStyle(
                                          color: _mainColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(result.recommendation,
                                  style: TextStyle(
                                      fontSize: isSmall ? 14 : 15,
                                      color: const Color(0xFF1A2B3C),
                                      height: 1.6,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        SizedBox(height: isSmall ? 20 : 30),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.refresh_rounded, size: 20),
                                label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(T.newScan,
                                        style: TextStyle(
                                            fontSize: isSmall ? 13 : 14))),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _mainColor,
                                  side: BorderSide(color: _mainColor, width: 2),
                                  padding: EdgeInsets.symmetric(
                                      vertical: isSmall ? 14 : 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(T.generating),
                                      backgroundColor: _mainColor,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  try {
                                    await PDFService.generateReport(
                                      result: result,
                                      image: image,
                                      riskLabel: _title,
                                    );
                                  } catch (e) {
                                    print('PDF Error: $e');
                                  }
                                },
                                icon: const Icon(Icons.picture_as_pdf_rounded,
                                    size: 20),
                                label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(T.saveReport,
                                        style: TextStyle(
                                            fontSize: isSmall ? 13 : 14))),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _mainColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: isSmall ? 14 : 16),
                                  elevation: 10,
                                  shadowColor: _mainColor.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskBox(DetectedRisk risk) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final ymin = risk.bbox[0];
        final xmin = risk.bbox[1];
        final ymax = risk.bbox[2];
        final xmax = risk.bbox[3];

        final left = xmin * w;
        final top = ymin * h;
        final boxW = (xmax - xmin) * w;
        final boxH = (ymax - ymin) * h;

        return Positioned(
          left: left,
          top: top,
          width: boxW.clamp(40, w),
          height: boxH.clamp(30, h),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: _mainColor, width: 3),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: _mainColor.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -22,
                  left: 0,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _mainColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${risk.name} ${risk.confidence}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}