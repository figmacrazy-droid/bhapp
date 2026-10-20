import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
                  T.history,
                  style: TextStyle(
                    fontSize: isSmall ? 24 : 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2B3C),
                  ),
                ),
                SizedBox(height: isSmall ? 20 : 25),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: isSmall ? 60 : 80,
                        color: const Color(0xFFB8C5D1),
                      ),
                      SizedBox(height: isSmall ? 16 : 20),
                      Text(
                        AppLanguage.isArabic
                            ? 'لا يوجد فحوصات سابقة'
                            : 'No previous scans',
                        style: TextStyle(
                          fontSize: isSmall ? 15 : 16,
                          color: const Color(0xFF7A8B9C),
                        ),
                      ),
                      SizedBox(height: isSmall ? 8 : 12),
                      Text(
                        AppLanguage.isArabic
                            ? 'سيظهر تاريخ الفحوصات هنا'
                            : 'Scan history will appear here',
                        style: TextStyle(
                          fontSize: isSmall ? 13 : 14,
                          color: const Color(0xFFB8C5D1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}