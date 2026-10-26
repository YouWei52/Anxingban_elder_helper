import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/api/api_client.dart';
import '../../core/auth/elder_session.dart';
import '../../core/theme/app_theme.dart';
import '../guide/guide_screen.dart';

class ElderHomeScreen extends StatefulWidget {
  const ElderHomeScreen({super.key});

  @override
  State<ElderHomeScreen> createState() => _ElderHomeScreenState();
}

class _ElderHomeScreenState extends State<ElderHomeScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isSOSLoading = false;
  Map<String, dynamic>? _elderInfo;
  int? _profileId;

  @override
  void initState() {
    super.initState();
    _loadElderInfo();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  Future<void> _loadElderInfo() async {
    try {
      final info = await _apiClient.getElderInfo();
      final savedProfileId = await ElderSession.profileId();
      setState(() {
        _elderInfo = info;
        _profileId = savedProfileId;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('加载信息失败：${e.toString()}')));
      }
    }
  }

  Future<void> _triggerSOS() async {
    if (_profileId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请先选择档案')));
      return;
    }

    setState(() => _isSOSLoading = true);

    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (_) {}

      await _apiClient.triggerSOS({
        'profile_id': _profileId!,
        'latitude': position?.latitude ?? 0.0,
        'longitude': position?.longitude ?? 0.0,
        'network_status': 'online',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('紧急求助已发送！子女已收到通知'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发送失败：${e.toString()}'),
            backgroundColor: AppTheme.dangerColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSOSLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('安行伴'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎卡片
            Card(
              color: AppTheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '您好，${_elderInfo?['name'] ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '祝您今天旅途愉快！',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SOS 紧急求助按钮
            SizedBox(
              width: double.infinity,
              height: 120,
              child: ElevatedButton(
                onPressed: _isSOSLoading ? null : () => _showSOSConfirm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.dangerColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
                child: _isSOSLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '紧急求助 SOS',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // 功能列表 - 横贯样式
            const Text(
              '快捷功能',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.explore,
              title: '景点讲解',
              subtitle: '了解周边景点信息',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuideScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.photo_library,
              title: '我的回忆',
              subtitle: '查看旅行照片和记录',
              color: Colors.orange,
              onTap: () {
                // 切换到回忆页签
                final nav = context.findAncestorStateOfType<State>();
                if (nav != null) {
                  // TODO: 通知主导航切换到回忆页签
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSOSConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认紧急求助'),
        content: const Text('确定要发送紧急求助信号吗？\n\n这将通知您的紧急联系人。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _triggerSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('确认发送'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 28, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
