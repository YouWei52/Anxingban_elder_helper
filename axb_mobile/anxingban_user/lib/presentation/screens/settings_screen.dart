import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: '通用',
            children: [
              _buildSettingItem(
                context,
                icon: Icons.notifications_outlined,
                title: '消息通知',
                subtitle: '管理推送通知设置',
                onTap: () {},
              ),
              _buildSettingItem(
                context,
                icon: Icons.language_outlined,
                title: '语言',
                subtitle: '简体中文',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            context,
            title: '隐私',
            children: [
              _buildSettingItem(
                context,
                icon: Icons.lock_outline,
                title: '隐私设置',
                subtitle: '管理您的隐私选项',
                onTap: () {},
              ),
              _buildSettingItem(
                context,
                icon: Icons.security_outlined,
                title: '账号安全',
                subtitle: '修改密码、绑定手机等',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            context,
            title: '其他',
            children: [
              _buildSettingItem(
                context,
                icon: Icons.delete_outline,
                title: '清除缓存',
                subtitle: '0.0 MB',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
