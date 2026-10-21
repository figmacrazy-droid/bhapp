import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/translations.dart';

/// Asks the user (once) for explicit permission before any photo is sent
/// to the third-party AI provider. Required by App Store Review
/// Guideline 5.1.1 / 5.1.2(i).
class AIConsent {
  static const String _key = 'ai_data_sharing_consent_v1';

  static Future<bool> hasConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> revoke() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Returns true if the user has agreed (now or previously).
  static Future<bool> ensure(BuildContext context) async {
    if (await hasConsent()) return true;
    if (!context.mounted) return false;

    final ar = AppLanguage.isArabic;
    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          title: Text(ar ? 'مشاركة الصورة للتحليل' : 'Share Photo for Analysis'),
          content: SingleChildScrollView(
            child: Text(
              ar
                  ? 'لتحليل مخاطر السلامة، سيتم إرسال الصورة التي تختارها فقط إلى خدمة ذكاء اصطناعي خارجية (Groq, Inc.) لمعالجتها وإرجاع النتيجة.\n\n'
                      '• لا نرسل اسمك أو موقعك أو أي بيانات شخصية أخرى.\n'
                      '• لا يتم حفظ الصورة على خوادمنا.\n'
                      '• يمكنك سحب الموافقة في أي وقت من الإعدادات.\n\n'
                      'هل توافق على إرسال الصور للتحليل؟'
                  : 'To analyze safety risks, only the photo you choose is sent to a third-party AI service (Groq, Inc.) for processing, and the result is returned to you.\n\n'
                      '• We do not send your name, location or any other personal data.\n'
                      '• Photos are not stored on our servers.\n'
                      '• You can withdraw consent at any time in Settings.\n\n'
                      'Do you agree to send photos for analysis?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(ar ? 'لا أوافق' : 'Don\'t Allow'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(ar ? 'أوافق' : 'Agree'),
            ),
          ],
        ),
      ),
    );

    if (agreed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, true);
      return true;
    }
    return false;
  }
}
