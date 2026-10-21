import 'package:flutter/material.dart';
import '../utils/translations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const String _ar = '''
آخر تحديث: أكتوبر 2026

1. البيانات التي نجمعها
لا نطلب إنشاء حساب ولا نجمع اسمك أو بريدك أو موقعك. البيانات الوحيدة التي يعالجها التطبيق هي الصور التي تختارها أنت للفحص.

2. كيف تُستخدم الصور
عند الضغط على الفحص وبعد موافقتك الصريحة، تُرسل الصورة فقط إلى خدمة الذكاء الاصطناعي لدى Groq, Inc. لتحليل مخاطر السلامة وإرجاع النتيجة. لا تُستخدم الصور للإعلانات أو التتبع، ولا نخزنها على أي خادم تابع لنا.

3. التخزين على جهازك
سجل الفحوصات وإعدادات اللغة تُحفظ محلياً على جهازك فقط، ويمكنك حذفها بحذف التطبيق.

4. مشاركة البيانات
لا نبيع بياناتك ولا نشاركها مع أي طرف سوى مزود الذكاء الاصطناعي المذكور لغرض التحليل فقط.

5. سحب الموافقة
يمكنك سحب الموافقة على مشاركة الصور في أي وقت من: الإعدادات ← سحب موافقة مشاركة الصور.

6. الأطفال
التطبيق غير موجه للأطفال دون 13 عاماً.

7. التواصل
لأي استفسار حول الخصوصية تواصل معنا عبر بريد الدعم المذكور في صفحة التطبيق على App Store.
''';

  static const String _en = '''
Last updated: October 2026

1. Data We Collect
No account is required. We do not collect your name, email or location. The only data processed is the photos you choose to scan.

2. How Photos Are Used
When you start a scan, and only after your explicit consent, the photo is sent to the AI service of Groq, Inc. to analyze safety risks and return the result. Photos are not used for advertising or tracking and are not stored on any server of ours.

3. On-Device Storage
Scan history and language settings are stored locally on your device only and are removed when you delete the app.

4. Data Sharing
We do not sell your data or share it with anyone other than the AI provider above, solely for analysis.

5. Withdrawing Consent
You can withdraw photo-sharing consent at any time in Settings → Withdraw Photo Sharing Consent.

6. Children
The app is not directed to children under 13.

7. Contact
For privacy questions, contact us via the support email listed on the App Store page.
''';

  @override
  Widget build(BuildContext context) {
    final ar = AppLanguage.isArabic;
    return Directionality(
      textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ar ? 'سياسة الخصوصية' : 'Privacy Policy'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(
              ar ? _ar : _en,
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
          ),
        ),
      ),
    );
  }
}
