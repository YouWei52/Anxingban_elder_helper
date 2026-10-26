import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/auth/elder_session.dart';
import '../../main.dart';
import '../auth/elder_login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await ElderSession.token();
    if (token != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: const Icon(Icons.favorite, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Text('安行伴', style: AppTheme.heading1),
            const SizedBox(height: 16),
            Text(
              '长辈出行好帮手',
              style: AppTheme.bodyLarge.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ElderLoginScreen()),
                );
              },
              style: AppTheme.primaryButton(),
              child: const Text('开始使用'),
            ),
          ],
        ),
      ),
    );
  }
}
