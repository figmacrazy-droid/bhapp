import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/ai_result.dart';
import '../models/detected_risk.dart';

class AIService {
  static Future<AIResult> analyzeImage(File image, {int maxRetries = 3}) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('=== Attempt $attempt of $maxRetries ===');

        final prompt = '''
أنت خبير سلامة مهنية. حلل هذه الصورة بدقة واكشف جميع مخاطر السلامة الظاهرة واشرح كل ما تراه.

ابحث عن:
1. أسلاك كهربائية مكشوفة
2. أرضيات مبللة (خطر انزلاق)
3. مخرج طوارئ محجوب
4. أشياء تسد الممرات
5. حريق أو دخان
6. أي خطر سلامة آخر

**مهم جداً:** حدد موقع كل خطر في الصورة بإحداثيات تقريبية (0.0 إلى 1.0):
- ymin: أعلى الخطر (0=أعلى الصورة، 1=أسفلها)
- xmin: يسار الخطر (0=يسار، 1=يمين)
- ymax: أسفل الخطر
- xmax: يمين الخطر

**مهم جداً:** اكتب في حقل "description" وصفاً تفصيلياً لما تراه في الصورة.

أجب بصيغة JSON فقط (بدون أي نص إضافي أو علامات markdown):
{
  "risk_level": "high" أو "medium" أو "low",
  "title": "عنوان مختصر للخطر الرئيسي",
  "description": "وصف تفصيلي",
  "recommendation": "التوصية",
  "confidence": رقم من 0 إلى 100,
  "risks": [
    {
      "name": "اسم الخطر بالعربية",
      "confidence": رقم,
      "bbox": [ymin, xmin, ymax, xmax]
    }
  ]
}

إذا لم توجد مخاطر، اجعل risk_level = "low" و title = "لا توجد مخاطر" و risks = [].
''';

        final response = await http.post(
          Uri.parse(GROQ_API_URL),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $GROQ_API_KEY',
          },
          body: jsonEncode({
            "model": GROQ_MODEL,
            "messages": [
              {
                "role": "user",
                "content": [
                  {"type": "text", "text": prompt},
                  {
                    "type": "image_url",
                    "image_url": {
                      "url": "data:image/jpeg;base64,$base64Image",
                    }
                  }
                ]
              }
            ],
            "temperature": 0.3,
            "response_format": {"type": "json_object"},
            "max_tokens": 2048,
          }),
        ).timeout(API_TIMEOUT);

        print('=== Groq Status: ${response.statusCode} ===');

        if (response.statusCode == 200) {
          print('=== Groq Success ===');
          final data = jsonDecode(response.body);
          final text = data['choices'][0]['message']['content'];

          String cleanText = text.trim();
          if (cleanText.startsWith('```')) {
            cleanText = cleanText
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();
          }

          final parsed = jsonDecode(cleanText);

          final List<DetectedRisk> risks = [];
          if (parsed['risks'] != null && parsed['risks'] is List) {
            for (var r in parsed['risks']) {
              risks.add(DetectedRisk.fromJson(r));
            }
          }

          return AIResult(
            riskLevel: parsed['risk_level'] ?? 'low',
            riskTitle: parsed['title'] ?? 'غير محدد',
            riskDesc: parsed['description'] ?? '',
            recommendation: parsed['recommendation'] ?? '',
            confidence: (parsed['confidence'] ?? 0).toInt(),
            risks: risks,
            description: parsed['description'] ?? '',
          );
        }

        if (response.statusCode == 429 || response.statusCode == 503) {
          print('=== Server busy, retrying... ===');
          if (attempt < maxRetries) {
            await Future.delayed(Duration(seconds: 3 * attempt));
            continue;
          }
        }

        print('=== Error Body ===');
        print(response.body);
      } catch (e) {
        print('=== Attempt $attempt failed: $e ===');
        if (attempt < maxRetries) {
          await Future.delayed(Duration(seconds: 3 * attempt));
          continue;
        }
      }
    }

    return AIResult(
      riskLevel: 'medium',
      riskTitle: 'تعذر التحليل',
      riskDesc: 'السيرفر مشغول حالياً، حاول مرة أخرى بعد دقيقة',
      recommendation: 'أعد المحاولة بعد قليل',
      confidence: 0,
      risks: [],
      description: 'لم نتمكن من تحليل الصورة',
    );
  }
}