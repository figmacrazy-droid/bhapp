import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/ai_result.dart';
import '../utils/translations.dart';

class PDFService {
  static Future<void> generateReport({
    required AIResult result,
    required File image,
    required String riskLabel,
  }) async {
    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final arabicFont = pw.Font.ttf(fontData);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFont),
    );

    final imageBytes = await image.readAsBytes();
    final pdfImage = pw.MemoryImage(imageBytes);

    final color = result.riskLevel == 'high'
        ? PdfColor.fromHex('#E53935')
        : result.riskLevel == 'medium'
        ? PdfColor.fromHex('#FB8C00')
        : PdfColor.fromHex('#43A047');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#0099CC'),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  T.reportTitle,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.Text(
                  DateTime.now().toString().substring(0, 16),
                  style: pw.TextStyle(fontSize: 11, color: PdfColors.white),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: color, width: 4),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Image(pdfImage, width: 400, height: 300, fit: pw.BoxFit.cover),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: color,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Center(
              child: pw.Text(
                '${T.reportLevel}: $riskLabel',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          _buildSection(T.reportDesc, result.riskTitle, result.riskDesc),
          pw.SizedBox(height: 12),
          _buildSection(T.reportRec, '', result.recommendation),
          if (result.risks.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text('المخاطر المكتشفة:',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...result.risks.map((r) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FFF3E0'),
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: color, width: 1),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('• ${r.name}', style: pw.TextStyle(fontSize: 13)),
                  pw.Text('${r.confidence}%',
                      style: pw.TextStyle(fontSize: 12, color: color)),
                ],
              ),
            )),
          ],
          pw.Spacer(),
          pw.Divider(),
          pw.Center(
            child: pw.Text(T.generatedBy,
                style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/safety_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'safety_report.pdf');
  }

  static pw.Widget _buildSection(String title, String subtitle, String body) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8FBFD'),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColor.fromHex('#E0EBF2'), width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title,
              style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#0099CC'))),
          if (subtitle.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            pw.Text(subtitle,
                style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
          ],
          pw.SizedBox(height: 6),
          pw.Text(body, style: const pw.TextStyle(fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}