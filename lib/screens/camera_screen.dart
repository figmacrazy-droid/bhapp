import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/ai_service.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';
import 'result_screen.dart';
import 'widgets/corner_painter.dart';
import 'widgets/hud_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = false;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _retrieveLostData();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _retrieveLostData() async {
    try {
      final LostDataResponse response = await _picker.retrieveLostData();

      if (response.isEmpty) {
        print('=== No lost data ===');
        return;
      }

      if (response.file != null) {
        print('=== LOST DATA RECOVERED: ${response.file!.path} ===');
        final File recoveredFile = File(response.file!.path);

        if (await recoveredFile.exists()) {
          setState(() {
            _pickedImage = recoveredFile;
            _isScanning = true;
          });

          final result = await AIService.analyzeImage(recoveredFile);

          if (!mounted) return;

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                result: result,
                image: recoveredFile,
              ),
            ),
          );

          if (mounted) {
            setState(() {
              _pickedImage = null;
              _isScanning = false;
            });
          }
        }
      }
    } catch (e) {
      print('=== Retrieve lost data error: $e ===');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    print('=== _pickImage START: $source ===');

    if (_isScanning) {
      setState(() {
        _isScanning = false;
        _pickedImage = null;
      });
      await Future.delayed(const Duration(milliseconds: 200));
    }

    try {
      final XFile? image = await _picker.pickImage(source: source);
      print('=== Picker RETURNED: ${image?.path} ===');

      if (image == null) return;
      if (!mounted) return;

      final File pickedFile = File(image.path);
      if (!await pickedFile.exists()) return;

      setState(() {
        _pickedImage = pickedFile;
        _isScanning = true;
      });

      final result = await AIService.analyzeImage(pickedFile);
      print('=== AI DONE ===');

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            result: result,
            image: pickedFile,
          ),
        ),
      );

      if (mounted) {
        setState(() {
          _pickedImage = null;
          _isScanning = false;
        });
      }
    } catch (e, stack) {
      print('=== ERROR: $e ===');
      print('=== STACK: $stack ===');

      if (mounted) {
        setState(() {
          _isScanning = false;
          _pickedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = Responsive.screenWidth(context);
    final sh = Responsive.screenHeight(context);
    final isSmall = sh < 700;

    final hudSize = (sw * 0.72).clamp(200.0, 320.0);
    final primarySize = isSmall ? 64.0 : 72.0;
    final secondarySize = isSmall ? 52.0 : 58.0;
    final primaryIcon = isSmall ? 28.0 : 32.0;
    final secondaryIcon = isSmall ? 22.0 : 26.0;
    final labelSize = isSmall ? 10.0 : 11.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: _pickedImage != null
                      ? Image.file(
                    _pickedImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.black),
                  )
                      : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1A2B3C), Color(0xFF0A192F)],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: hudSize,
                    height: hudSize,
                    child: Stack(
                      children: [
                        ..._corners(),
                        if (_isScanning)
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) => Positioned(
                              top: _controller.value * hudSize,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF00E5FF),
                                      Colors.transparent
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00E5FF)
                                          .withOpacity(0.8),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_pickedImage == null && !_isScanning)
                  Positioned(
                    top: isSmall ? 30 : 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_rounded,
                            size: isSmall ? 50 : 70,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            T.pointCamera,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmall ? 13 : 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_isScanning)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: Color(0xFF00E5FF),
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                T.analyzing,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmall ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                T.analyzingDesc,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isSmall ? 12 : 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!_isScanning)
                  Positioned(
                    bottom: isSmall ? 20 : 30,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HudButton(
                            icon: Icons.photo_library_rounded,
                            label: T.fromGallery,
                            onTap: () => _pickImage(ImageSource.gallery),
                            size: secondarySize,
                            iconSize: secondaryIcon,
                            labelSize: labelSize,
                          ),
                          HudButton(
                            icon: Icons.camera_alt_rounded,
                            label: T.takePhoto,
                            onTap: () => _pickImage(ImageSource.camera),
                            isPrimary: true,
                            size: primarySize,
                            iconSize: primaryIcon,
                            labelSize: labelSize,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _corners() {
    const color = Color(0xFF00E5FF);
    const width = 3.0;
    const len = 40.0;
    return [
      Positioned(top: 0, left: 0, child: _corner(color, width, len, false, false)),
      Positioned(top: 0, right: 0, child: _corner(color, width, len, false, true)),
      Positioned(bottom: 0, left: 0, child: _corner(color, width, len, true, false)),
      Positioned(bottom: 0, right: 0, child: _corner(color, width, len, true, true)),
    ];
  }

  Widget _corner(Color color, double width, double len, bool bottom, bool right) {
    return SizedBox(
      width: len,
      height: len,
      child: CustomPaint(
        painter: CornerPainter(
            color: color, width: width, bottom: bottom, right: right),
      ),
    );
  }
}