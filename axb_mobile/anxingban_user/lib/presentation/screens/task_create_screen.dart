import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../widgets/custom_text_field.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final profileProvider = context.read<ProfileProvider>();
    final selectedProfile = profileProvider.selectedProfile;

    if (selectedProfile == null) {
      DialogUtils.showErrorSnackBar(context, '请先选择一个档案');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 调用API创建任务
      // await taskRepository.createTask(...)

      await Future.delayed(const Duration(seconds: 1)); // 模拟API调用

      if (mounted) {
        DialogUtils.showSuccessSnackBar(context, '任务创建成功！');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        DialogUtils.showErrorSnackBar(context, '创建失败：${e.toString()}');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建任务'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                label: '任务标题',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入任务标题';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _descriptionController,
                label: '任务描述',
                prefixIcon: Icons.description,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入任务描述';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isLoading ? null : _handleCreate,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('创建任务'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
