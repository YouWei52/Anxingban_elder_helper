import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/date_formatter.dart';

class ProfilesListScreen extends StatefulWidget {
  const ProfilesListScreen({super.key});

  @override
  State<ProfilesListScreen> createState() => _ProfilesListScreenState();
}

class _ProfilesListScreenState extends State<ProfilesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              if (profileProvider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (profileProvider.profiles.isEmpty) {
                return SliverFillRemaining(child: _buildEmptyState());
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverAnimatedList(
                  initialItemCount: profileProvider.profiles.length,
                  itemBuilder: (context, index, animation) {
                    final profile = profileProvider.profiles[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildProfileCard(profile, index),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProfileDialog(),
        icon: const Icon(Icons.add),
        label: const Text('添加档案'),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          '老人档案',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom_outlined,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无档案',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text('点击右下角按钮添加老人档案', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildProfileCard(dynamic profile, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.read<ProfileProvider>().selectProfile(profile);
          DialogUtils.showInfoSnackBar(context, '已选择档案 #${profile.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '档案 #${profile.id}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        if (context
                                .watch<ProfileProvider>()
                                .selectedProfile
                                ?.id ==
                            profile.id)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '已选择',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '老人ID: ${profile.elderId}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '创建时间: ${DateFormatter.formatDate(profile.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => _confirmDelete(profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProfileDialog() {
    final elderIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('添加老人档案'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: elderIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '老人ID',
                hintText: '请输入老人账号ID',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '提示：老人ID可以在老人端个人中心查看',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final elderId = int.tryParse(elderIdController.text.trim());
              if (elderId == null) {
                DialogUtils.showErrorSnackBar(context, '请输入有效的老人ID');
                return;
              }

              Navigator.pop(context);

              final authProvider = context.read<AuthProvider>();
              final userId = authProvider.currentUser?.id;

              if (userId == null) {
                DialogUtils.showErrorSnackBar(context, '用户信息无效');
                return;
              }

              final profileProvider = context.read<ProfileProvider>();
              final success = await profileProvider.createProfile(
                elderId: elderId,
                userId: userId,
              );

              if (mounted) {
                if (success) {
                  DialogUtils.showSuccessSnackBar(context, '档案添加成功！');
                } else {
                  DialogUtils.showErrorSnackBar(
                    context,
                    profileProvider.error ?? '添加失败',
                  );
                }
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(dynamic profile) async {
    final confirmed = await DialogUtils.showConfirmDialog(
      context,
      title: '删除档案',
      content: '确定要删除档案 #${profile.id} 吗？',
      confirmText: '删除',
      cancelText: '取消',
    );

    if (confirmed == true && mounted) {
      final success = await context.read<ProfileProvider>().deleteProfile(
        profile.id,
      );

      if (mounted) {
        if (success) {
          DialogUtils.showSuccessSnackBar(context, '档案已删除');
        } else {
          DialogUtils.showErrorSnackBar(
            context,
            context.read<ProfileProvider>().error ?? '删除失败',
          );
        }
      }
    }
  }
}
