import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/ai_service.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';
import 'onboarding_screen.dart';
import 'result_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _rippleController;
  late AnimationController _glowController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _ripple;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    _rippleController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _ripple = Tween<double>(begin: 0.0, end: 1.0).animate(_rippleController);

    _glowController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 2500));

    File? pendingFile;
    final imagePicker = ImagePicker();

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        print('=== Splash check attempt $attempt/3 ===');
        final LostDataResponse response = await imagePicker.retrieveLostData();

        if (!response.isEmpty && response.file != null) {
          final file = File(response.file!.path);
          if (await file.exists()) {
            pendingFile = file;
            print('=== 🎯 FOUND PENDING SCAN ===');
            break;
          }
        } else {
          print('=== Attempt $attempt: No data yet ===');
        }
      } catch (e) {
        print('=== Attempt $attempt error: $e ===');
      }

      if (attempt < 3) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (!mounted) return;

    if (pendingFile != null) {
      print('=== ✅ Going to AnalyzingScreen ===');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) =>
              _AnalyzingScreen(imageFile: pendingFile!),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      print('=== Normal flow → Onboarding ===');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _rippleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = Responsive.screenWidth(context);
    final sh = Responsive.screenHeight(context);
    final isSmall = sh < 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFFAFDFF), Color(0xFFF0F8FC)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _glowCorner(
                  top: -200,
                  right: -150,
                  color: const Color(0xFF00B4D8),
                  opacity: 0.15),
              _glowCorner(
                  bottom: -200,
                  left: -150,
                  color: const Color(0xFFC9A961),
                  opacity: 0.1),
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w(context, 20),
                        vertical: Responsive.h(context, 20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: isSmall ? sw * 0.75 : sw * 0.9,
                          height: isSmall ? sw * 0.75 : sw * 0.9,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildRipple(0.0, sw),
                              _buildRipple(0.5, sw),
                              _buildCenterGlow(sw),
                              _buildLogo(context, sw),
                            ],
                          ),
                        ),
                        SizedBox(height: Responsive.h(context, 30)),
                        _buildTextSection(context),
                        SizedBox(height: Responsive.h(context, 40)),
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

  Widget _glowCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Color color,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _glow,
        builder: (context, _) => Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withOpacity(opacity * _glow.value),
                color.withOpacity(opacity * 0.3),
                Colors.transparent
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRipple(double delay, double screenWidth) {
    final baseSize = screenWidth * 0.55;
    final maxExtra = screenWidth * 0.45;
    return AnimatedBuilder(
      animation: _ripple,
      builder: (context, _) {
        final val = (_ripple.value + delay) % 1.0;
        final size = baseSize + (val * maxExtra);
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00B4D8).withOpacity((1 - val) * 0.4),
              width: 1.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterGlow(double screenWidth) {
    final base = screenWidth * 0.65;
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, _) => Container(
        width: base * _glow.value,
        height: base * _glow.value,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            const Color(0xFF00B4D8).withOpacity(0.25 * _glow.value),
            Colors.transparent
          ]),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, double screenWidth) {
    final logoSize = screenWidth * 0.48;
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, _) => Transform.scale(
        scale: _logoScale.value,
        child: Opacity(
          opacity: _logoFade.value,
          child: Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                  color: const Color(0xFF00B4D8).withOpacity(0.2), width: 2),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF00B4D8).withOpacity(0.3),
                    blurRadius: 50,
                    spreadRadius: 8,
                    offset: const Offset(0, 15)),
                BoxShadow(
                    color: const Color(0xFFC9A961).withOpacity(0.15),
                    blurRadius: 80,
                    spreadRadius: 15),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0099CC), Color(0xFF00B4D8)],
                    ),
                  ),
                  child: Icon(Icons.shield_rounded,
                      color: Colors.white, size: logoSize * 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextSection(BuildContext context) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, _) => Transform.translate(
        offset: Offset(0, _textSlide.value),
        child: Opacity(
          opacity: _textFade.value,
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF0077B6),
                    Color(0xFF00B4D8),
                    Color(0xFFC9A961)
                  ],
                  stops: [0.0, 0.6, 1.0],
                ).createShader(bounds),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    T.appName,
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 42),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  T.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Responsive.sp(context, 14),
                      color: const Color(0xFF7A8B9C),
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 40,
            height: 1,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  const Color(0xFF00B4D8).withOpacity(0.5)
                ]))),
        const SizedBox(width: 10),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
                colors: [Color(0xFFC9A961), Color(0xFFE5C77E)]),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFC9A961).withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 2)
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
            width: 40,
            height: 1,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xFF00B4D8).withOpacity(0.5),
                  Colors.transparent
                ]))),
      ],
    );
  }
}

class _AnalyzingScreen extends StatefulWidget {
  final File imageFile;

  const _AnalyzingScreen({required this.imageFile});

  @override
  State<_AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<_AnalyzingScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _dotController;
  late Animation<double> _scanPosition;
  late Animation<double> _pulse;
  late Animation<double> _dots;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _scanPosition = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));

    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _dotController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
    _dots = Tween<double>(begin: 0.0, end: 1.0).animate(_dotController);

    _startAnalysis();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  Future<void> _startAnalysis() async {
    print('=== 🚀 Auto-analysis START ===');

    final result = await AIService.analyzeImage(widget.imageFile);

    print('=== ✅ Analysis DONE ===');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => ResultScreen(
          result: result,
          image: widget.imageFile,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = Responsive.screenWidth(context);
    final sh = Responsive.screenHeight(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),

          AnimatedBuilder(
            animation: _scanPosition,
            builder: (context, _) {
              return Positioned(
                top: sh * _scanPosition.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFF00E5FF),
                        Color(0xFF00E5FF),
                        Color(0xFF00E5FF),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withOpacity(0.9),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: sh * 0.18,
            left: sw * 0.1,
            child: _corner(sw * 0.09, false, false),
          ),
          Positioned(
            top: sh * 0.18,
            right: sw * 0.1,
            child: _corner(sw * 0.09, false, true),
          ),
          Positioned(
            bottom: sh * 0.22,
            left: sw * 0.1,
            child: _corner(sw * 0.09, true, false),
          ),
          Positioned(
            bottom: sh * 0.22,
            right: sw * 0.1,
            child: _corner(sw * 0.09, true, true),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) {
                    return Transform.scale(
                      scale: _pulse.value,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00E5FF)
                                      .withOpacity(0.2),
                                  width: 3,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                color: Color(0xFF00E5FF),
                                strokeWidth: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                const Text(
                  'جاري التحليل...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  'الذكاء الاصطناعي يفحص الصورة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _dots,
              builder: (context, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final delay = i * 0.33;
                    final val = (_dots.value + delay) % 1.0;
                    final opacity = 0.3 + (val * 0.7);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF00E5FF).withOpacity(opacity),
                        boxShadow: [
                          BoxShadow(
                            color:
                            const Color(0xFF00E5FF).withOpacity(opacity * 0.6),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner(double size, bool bottom, bool right) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CornerPainter(bottom: bottom, right: right),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool bottom;
  final bool right;

  _CornerPainter({required this.bottom, required this.right});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (!bottom && !right) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (!bottom && right) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (bottom && !right) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}