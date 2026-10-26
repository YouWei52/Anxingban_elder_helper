import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';
import '../../core/auth/elder_session.dart';
import '../../core/theme/app_theme.dart';
import '../welcome/welcome_screen.dart';
import 'elder_pair_screen.dart';

class ElderProfileScreen extends StatefulWidget {
  const ElderProfileScreen({super.key});

  @override
  State<ElderProfileScreen> createState() => _ElderProfileScreenState();
}

class _ElderProfileScreenState extends State<ElderProfileScreen> {
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _elderInfo;
  List<dynamic> _profiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final info = await _apiClient.getElderInfo();
      final profiles = await _apiClient.getProfiles();
      if (mounted) {
        setState(() {
          _elderInfo = info;
          _profiles = profiles;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('加载失败：${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 用户信息卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _elderInfo?['name'] ?? '未知',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _elderInfo?['phone'] ?? '',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 档案列表
                  if (_profiles.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '我的档案',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._profiles.map((profile) => _buildProfileCard(profile)),
                  ],
                  const SizedBox(height: 16),

                  // 设置选项
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.link),
                          title: const Text('安全配对'),
                          subtitle: const Text('查看我的账号ID'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ElderPairScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('关于安行伴'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showAbout(),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.help_outline),
                          title: const Text('帮助中心'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('功能开发中')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    final currentProfileId = ElderSession.profileId();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: const Icon(Icons.folder_shared, color: AppTheme.accentColor),
        ),
        title: Text('档案 #${profile['id']}'),
        subtitle: Text('创建于 ${profile['created_at'] ?? ''}'),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle),
          color: AppTheme.successColor,
          onPressed: () async {
            await ElderSession.setProfileId(profile['id']);
            if (mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('已选择该档案')));
            }
          },
        ),
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于安行伴'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('安行伴 - 长辈出行好帮手'),
            SizedBox(height: 16),
            Text('版本：1.0.0'),
            SizedBox(height: 8),
            Text('© 2026 安行伴团队'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ElderSession.clear();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}
