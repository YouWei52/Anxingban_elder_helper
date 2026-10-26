import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/elder/elder_login_screen.dart';
import 'screens/elder/elder_home_screen.dart';
import 'screens/elder/elder_memory_screen.dart';
import 'screens/elder/elder_journey_screen.dart';
import 'screens/elder/elder_profile_screen.dart';

void main() {
  runApp(const AnxingbanApp());
}

class AnxingbanApp extends StatelessWidget {
  const AnxingbanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '安行伴',
      theme: AppTheme.lightTheme,
      home: const ElderLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ElderHomeScreen(),
    const ElderMemoryScreen(),
    const ElderJourneyScreen(),
    const ElderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            activeIcon: Icon(Icons.photo_album),
            label: '回忆',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: '旅途',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
