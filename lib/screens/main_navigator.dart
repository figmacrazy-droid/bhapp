import 'package:flutter/material.dart';
import '../utils/translations.dart';
import 'home_screen.dart';
import 'camera_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const CameraScreen(),
      const HistoryScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF0099CC).withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, -10))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0099CC),
          unselectedItemColor: const Color(0xFFB8C5D1),
          selectedFontSize: 11,
          unselectedFontSize: 10,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded, size: 22), label: T.home),
            BottomNavigationBarItem(
                icon: const Icon(Icons.camera_alt_rounded, size: 22),
                label: T.scan),
            BottomNavigationBarItem(
                icon: const Icon(Icons.history_rounded, size: 22),
                label: T.history),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings_rounded, size: 22),
                label: T.settings),
          ],
        ),
      ),
    );
  }
}