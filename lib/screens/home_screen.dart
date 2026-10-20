import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/translations.dart';
import 'camera_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = Responsive.screenHeight(context);
    final isSmall = sh < 700;
    final logoSize = isSmall ? 110.0 : 130.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFFAFDFF), Color(0xFFF0F8FC)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(isSmall ? 20 : 24),
            child: Column(
              children: [
                SizedBox(height: isSmall ? 40 : 60),
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0099CC).withOpacity(0.3),
                        blurRadius: 50,
                        spreadRadius: 8,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Icon(Icons.shield_rounded,
                      color: const Color(0xFF0099CC), size: logoSize * 0.5),
                ),
                SizedBox(height: isSmall ? 30 : 40),
                Text(
                  T.appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: isSmall ? 28 : 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2B3C)),
                ),
                const SizedBox(height: 10),
                Text(
                  T.readyQuestion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: isSmall ? 15 : 16,
                      color: const Color(0xFF7A8B9C)),
                ),
                SizedBox(height: isSmall ? 60 : 90),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CameraScreen()),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: isSmall ? 65 : 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      gradient: const LinearGradient(
                          colors: [Color(0xFF0099CC), Color(0xFF00B4D8)]),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF0099CC).withOpacity(0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 15))
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded,
                              color: Colors.white, size: isSmall ? 24 : 26),
                          const SizedBox(width: 12),
                          Text(
                            T.startScan,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmall ? 18 : 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isSmall ? 15 : 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}