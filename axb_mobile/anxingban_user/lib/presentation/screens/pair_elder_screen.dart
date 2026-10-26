import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/dialog_utils.dart';
import '../../data/models/profile.dart';
import '../widgets/custom_text_field.dart';

class PairElderScreen extends StatefulWidget {
  const PairElderScreen({super.key});

  @override
  State<PairElderScreen> createState() => _PairElderScreenState();
}

class _PairElderScreenState extends State<PairElderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfiles();
    });
  }

  Future<void> _loadProfiles() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadProfiles();
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddElderSheet(),
    );
  }

  Future<void> _deleteProfile(Profile profile) async {
    final confirmed = await DialogUtils.showConfirmDialog(
      context,
      title: '确认解除绑定',
      content: '确定要解除与老人(ID: ${profile.elderId})的绑定吗？',
      confirmText: '解除',
      cancelText: '取消',
    );

    if (confirmed == true) {
      final profileProvider = context.read<ProfileProvider>();
      final success = await profileProvider.deleteProfile(profile.id);

      if (mounted) {
        if (success) {
          DialogUtils.showSuccessSnackBar(context, '已解除绑定');
        } else {
          DialogUtils.showErrorSnackBar(
            context,
            profileProvider.error ?? '解除失败',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('安全配对'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profiles = profileProvider.profiles;

          if (profiles.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              return _buildProfileCard(profiles[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('添加老人'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.link_off, size: 80, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            '暂无绑定的老人',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text('点击右下角按钮添加老人', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Profile profile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: 查看详情或切换当前档案
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.blueGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${profile.elderId}'.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '老人 #${profile.elderId}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${profile.elderId}',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                onPressed: () => _deleteProfile(profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddElderSheet extends StatefulWidget {
  const _AddElderSheet();

  @override
  State<_AddElderSheet> createState() => _AddElderSheetState();
}

class _AddElderSheetState extends State<_AddElderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _elderIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _elderIdController.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final elderIdText = _elderIdController.text.trim();
      final elderId = int.tryParse(elderIdText);

      if (elderId == null) {
        throw Exception('请输入有效的数字ID');
      }

      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.currentUser?.id;

      if (userId == null) {
        throw Exception('用户信息无效，请重新登录');
      }

      final profileProvider = context.read<ProfileProvider>();
      final success = await profileProvider.createProfile(
        elderId: elderId,
        userId: userId,
      );

      if (mounted) {
        if (success) {
          context.pop();
          DialogUtils.showSuccessSnackBar(context, '添加成功！');
          // 刷新列表
          await profileProvider.loadProfiles();
        } else {
          // 显示具体的错误信息
          final errorMsg = profileProvider.error ?? '添加失败，请稍后重试';
          DialogUtils.showErrorSnackBar(context, errorMsg);
        }
      }
    } catch (e) {
      if (mounted) {
        // 显示具体的异常信息
        final errorMsg = e.toString().replaceFirst('Exception: ', '');
        DialogUtils.showErrorSnackBar(context, errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildForm(),
            const SizedBox(height: 16),
            _buildTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.blueGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.elevation2Shadow,
          ),
          child: const Icon(Icons.person_add, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text('添加老人', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          '输入老人的账号ID即可建立关联',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _elderIdController,
            label: '老人账号ID',
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入老人账号ID';
              }
              if (int.tryParse(value) == null) {
                return '请输入有效的ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _isLoading ? null : _handleAdd,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('立即添加'),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.info, size: 20),
              const SizedBox(width: 8),
              Text(
                '温馨提示',
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: AppColors.info),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('1. 老人账号ID可在老人端"我的-安全配对"中查看'),
          _buildTipItem('2. 添加成功后，您可以为老人创建行程和任务'),
          _buildTipItem('3. 您可以同时关联多位老人'),
          _buildTipItem('4. 如需解除绑定，长按档案卡片即可删除'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
