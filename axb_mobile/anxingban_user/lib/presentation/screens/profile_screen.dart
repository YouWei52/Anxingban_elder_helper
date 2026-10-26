import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/dialog_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildUserInfo(context),
        const SizedBox(height: 24),
        _buildMenuSection(context),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user?.nickname.substring(0, 1) ?? '用',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.nickname ?? '阿斯蒂芬',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.phone ?? '13345678909',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.link,
          title: '安全配对',
          subtitle: '绑定老人手机号建立关联',
          onTap: () {
            context.push('/pair');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.family_restroom,
          title: '档案管理',
          subtitle: '管理关联的老人档案',
          onTap: () {
            context.push('/profiles');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.emergency_outlined,
          title: 'SOS记录',
          subtitle: '查看紧急求助历史',
          onTap: () {
            context.push('/sos');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.settings_outlined,
          title: '设置',
          subtitle: '应用设置和偏好',
          onTap: () {
            context.push('/settings');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.help_outline,
          title: '帮助与反馈',
          subtitle: '获取帮助或提交反馈',
          onTap: () {
            context.push('/help');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.info_outline,
          title: '关于',
          subtitle: '关于安行伴',
          onTap: () {
            context.push('/about');
          },
        ),
        const SizedBox(height: 24),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      color: AppColors.error.withOpacity(0.05),
      child: InkWell(
        onTap: () async {
          final confirmed = await DialogUtils.showConfirmDialog(
            context,
            title: '确认退出',
            content: '确定要退出登录吗？',
            confirmText: '退出',
            cancelText: '取消',
          );

          if (confirmed == true && context.mounted) {
            await context.read<AuthProvider>().logout();
            if (context.mounted) {
              context.go('/login');
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: AppColors.error),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  '退出登录',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
