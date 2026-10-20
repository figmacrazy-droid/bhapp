import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = Responsive.screenHeight(context);
    final isSmall = sh < 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFAFDFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Color(0xFF1A2B3C)),
                    ),
                    Text(T.termsOfService,
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
                    padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 20 : 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          isSmall,
                          T.termsIntro,
                          _getTermsIntro(),
                        ),
                        SizedBox(height: isSmall ? 20 : 24),
                        _buildSection(
                          isSmall,
                          T.termsDataCollection,
                          _getTermsDataCollection(),
                        ),
                        SizedBox(height: isSmall ? 20 : 24),
                        _buildSection(
                          isSmall,
                          T.termsUsage,
                          _getTermsUsage(),
                        ),
                        SizedBox(height: isSmall ? 20 : 24),
                        _buildSection(
                          isSmall,
                          T.termsDisclaimer,
                          _getTermsDisclaimer(),
                        ),
                        SizedBox(height: isSmall ? 20 : 24),
                        _buildSection(
                          isSmall,
                          T.termsLiability,
                          _getTermsLiability(),
                        ),
                        SizedBox(height: isSmall ? 20 : 24),
                        _buildSection(
                          isSmall,
                          T.termsChanges,
                          _getTermsChanges(),
                        ),
                        SizedBox(height: isSmall ? 20 : 24),
                        _buildSection(
                          isSmall,
                          T.termsContact,
                          _getTermsContact(),
                        ),
                        SizedBox(height: isSmall ? 30 : 40),
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

  Widget _buildSection(bool isSmall, String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0099CC).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0099CC),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: isSmall ? 13 : 14,
              color: const Color(0xFF4A5A6A),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _getTermsIntro() {
    return AppLanguage.isArabic
        ? 'تطبيق فحص السلامة هو تطبيق يستخدم الذكاء الاصطناعي للمساعدة في اكتشاف مخاطر السلامة في الصور. باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بشروط الاستخدام هذه.'
        : 'Safety Check is an AI-powered application designed to help detect safety risks in images. By using this app, you agree to comply with these Terms of Service.';
  }

  String _getTermsDataCollection() {
    return AppLanguage.isArabic
        ? '• التطبيق يصل إلى الكاميرا ومكتبة الصور لالتقاط أو اختيار الصور للتحليل.\n• الصور تُرسل إلى خدمة AI خارجية للتحليل.\n• لا نخزن الصور على خوادمنا بعد التحليل.\n• نستخدم ملفات تعريف الارتباط لتحسين تجربة المستخدم.'
        : '• The app accesses camera and photo library to capture or select images for analysis.\n• Images are sent to an external AI service for analysis.\n• We do not store images on our servers after analysis.\n• We use cookies to improve user experience.';
  }

  String _getTermsUsage() {
    return AppLanguage.isArabic
        ? '• يجب استخدام التطبيق لأغراض السلامة المهنية فقط.\n• لا تستخدم التطبيق لأغراض غير قانونية أو ضارة.\n• أنت مسؤول عن دقة المعلومات التي تقدمها.\n• التطبيق يقدم توصيات فقط وليس استشارات مهنية.'
        : '• Use the app for professional safety purposes only.\n• Do not use the app for illegal or harmful purposes.\n• You are responsible for the accuracy of information provided.\n• The app provides recommendations only, not professional advice.';
  }

  String _getTermsDisclaimer() {
    return AppLanguage.isArabic
        ? '• تحليلات الذكاء الاصطناعي قد لا تكون دقيقة بنسبة 100%.\n• التطبيق لا يضمن اكتشاف جميع المخاطر.\n• يجب دائماً التحقق يدوياً من نتائج التحليل.\n• لا تعتمد فقط على التطبيق لاتخاذ قرارات السلامة.'
        : '• AI analysis may not be 100% accurate.\n• The app does not guarantee detection of all risks.\n• Always manually verify analysis results.\n• Do not rely solely on the app for safety decisions.';
  }

  String _getTermsLiability() {
    return AppLanguage.isArabic
        ? '• نحن غير مسؤولين عن أي أضرار ناتجة عن استخدام التطبيق.\n• نحن غير مسؤولين عن قرارات السلامة المتخذة بناءً على نتائج التطبيق.\n• استخدام التطبيق على مسؤوليتك الخاصة.'
        : '• We are not liable for any damages resulting from app usage.\n• We are not responsible for safety decisions based on app results.\n• App usage is at your own risk.';
  }

  String _getTermsChanges() {
    return AppLanguage.isArabic
        ? '• نحتفظ بالحق في تعديل شروط الاستخدام في أي وقت.\n• سيتم إشعار المستخدمين بالتغييرات المهمة.\n• الاستمرار في استخدام التطبيق بعد التعديلات يعني الموافقة عليها.'
        : '• We reserve the right to modify terms at any time.\n• Users will be notified of significant changes.\n• Continued use after modifications indicates acceptance.';
  }

  String _getTermsContact() {
    return AppLanguage.isArabic
        ? 'لأي استفسارات أو شكاوى، يرجى التواصل معنا عبر:\nالبريد الإلكتروني: support@safetycheck.app\nالموقع الإلكتروني: www.safetycheck.app'
        : 'For any inquiries or complaints, please contact us at:\nEmail: support@safetycheck.app\nWebsite: www.safetycheck.app';
  }
}
