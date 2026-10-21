import 'package:flutter/material.dart';
import '../services/ai_consent.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final sh = Responsive.screenHeight(context);
    final isSmall = sh < 700;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFFAFDFF)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(isSmall ? 18 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmall ? 10 : 20),
                Text(
                  T.settings,
                  style: TextStyle(
                    fontSize: isSmall ? 24 : 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2B3C),
                  ),
                ),
                SizedBox(height: isSmall ? 20 : 25),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0099CC).withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.language_rounded,
                          color: Color(0xFF0099CC),
                        ),
                        title: Text(
                          T.language,
                          style: TextStyle(fontSize: isSmall ? 14 : 15),
                        ),
                        trailing: Text(
                          AppLanguage.isArabic ? 'العربية' : 'English',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0099CC),
                          ),
                        ),
                        onTap: () async {
                          await AppLanguage.setLanguage(!AppLanguage.isArabic);
                          setState(() {});
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF0099CC),
                        ),
                        title: Text(
                          T.about,
                          style: TextStyle(fontSize: isSmall ? 14 : 15),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: T.appName,
                            applicationVersion: '1.0.0',
                            applicationIcon: Image.asset(
                              'assets/images/app_icon.png',
                              width: 48,
                              height: 48,
                            ),
                            children: [
                              Text(AppLanguage.isArabic
                                  ? 'تطبيق يساعدك على اكتشاف مخاطر السلامة في الصور باستخدام الذكاء الاصطناعي. النتائج إرشادية ولا تغني عن فحص مختص.'
                                  : 'Detect safety hazards in photos using AI. Results are for guidance only and do not replace a professional inspection.'),
                            ],
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.privacy_tip_rounded,
                          color: Color(0xFF0099CC),
                        ),
                        title: Text(
                          AppLanguage.isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
                          style: TextStyle(fontSize: isSmall ? 14 : 15),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.block_rounded,
                          color: Color(0xFF0099CC),
                        ),
                        title: Text(
                          AppLanguage.isArabic
                              ? 'سحب موافقة مشاركة الصور'
                              : 'Withdraw Photo Sharing Consent',
                          style: TextStyle(fontSize: isSmall ? 14 : 15),
                        ),
                        onTap: () async {
                          await AIConsent.revoke();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLanguage.isArabic
                                  ? 'تم سحب الموافقة. سيُطلب منك الإذن قبل التحليل القادم.'
                                  : 'Consent withdrawn. You will be asked again before the next analysis.'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.description_rounded,
                          color: Color(0xFF0099CC),
                        ),
                        title: Text(
                          T.termsOfService,
                          style: TextStyle(fontSize: isSmall ? 14 : 15),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}