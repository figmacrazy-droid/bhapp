import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';
import 'main_navigator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> get _pages => [
    {
      'icon': Icons.camera_alt_rounded,
      'title': AppLanguage.isArabic ? 'صوّر المكان' : 'Capture Location',
      'desc': AppLanguage.isArabic
          ? 'التقط صورة لأي مكان داخل المنشأة\nواكتشف المخاطر في ثوانٍ'
          : 'Take a photo of any place\nand detect risks in seconds',
      'color': const Color(0xFF0099CC),
      'bgColor': const Color(0xFFE8F4F8),
    },
    {
      'icon': Icons.psychology_rounded,
      'title': AppLanguage.isArabic ? 'تحليل ذكي' : 'Smart Analysis',
      'desc': AppLanguage.isArabic
          ? 'الذكاء الاصطناعي يحلل الصورة\nويكتشف الأسلاك المكشوفة والعوائق والحريق'
          : 'AI analyzes the image\ndetects exposed wires & obstacles',
      'color': const Color(0xFF7B61FF),
      'bgColor': const Color(0xFFF0EEFF),
    },
    {
      'icon': Icons.verified_user_rounded,
      'title': AppLanguage.isArabic ? 'تقرير فوري' : 'Instant Report',
      'desc': AppLanguage.isArabic
          ? 'احصل على مستوى الخطر بالألوان\nمع التوصيات المناسبة للسلامة'
          : 'Get color-coded risk levels\nwith safety recommendations',
      'color': const Color(0xFF00A878),
      'bgColor': const Color(0xFFE6F7F1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sh = Responsive.screenHeight(context);
    final isSmall = sh < 700;
    final iconSize = isSmall ? 60.0 : 80.0;
    final circleSize = isSmall ? 160.0 : 200.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFAFDFF), Color(0xFFF0F8FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MainNavigator()));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: const Color(0xFF0099CC).withOpacity(0.2)),
                      ),
                    ),
                    child: Text(T.skip,
                        style: const TextStyle(
                            color: Color(0xFF6B7B8C),
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, i) {
                    final page = _pages[i];
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: isSmall ? 10 : 30),
                            Container(
                              width: circleSize,
                              height: circleSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: (page['color'] as Color)
                                          .withOpacity(0.25),
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 15))
                                ],
                              ),
                              child: Container(
                                margin: EdgeInsets.all(circleSize * 0.16),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: page['bgColor'] as Color),
                                child: Icon(page['icon'] as IconData,
                                    size: iconSize,
                                    color: page['color'] as Color),
                              ),
                            ),
                            SizedBox(height: isSmall ? 30 : 50),
                            Text(
                              page['title'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: isSmall ? 26 : 30,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A2B3C)),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 60,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.transparent,
                                  page['color'] as Color,
                                  Colors.transparent
                                ]),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                page['desc'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: isSmall ? 14 : 15,
                                    color: const Color(0xFF6B7B8C),
                                    height: 1.7,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: isSmall ? 20 : 40),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isSmall ? 20 : 28),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                            (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 35 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? _pages[i]['color'] as Color
                                : const Color(0xFFB8C5D1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmall ? 20 : 30),
                    SizedBox(
                      width: double.infinity,
                      height: isSmall ? 54 : 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MainNavigator()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage]['color'] as Color,
                          foregroundColor: Colors.white,
                          elevation: 15,
                          shadowColor:
                          (_pages[_currentPage]['color'] as Color)
                              .withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? T.startNow
                                  : T.next,
                              style: TextStyle(
                                  fontSize: isSmall ? 16 : 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded,
                                size: isSmall ? 20 : 22),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}