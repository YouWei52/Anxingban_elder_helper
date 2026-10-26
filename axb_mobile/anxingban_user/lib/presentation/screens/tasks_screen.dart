import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_outlined, size: 80, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              '暂无任务',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text('点击右下角按钮创建新任务', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/create'),
        icon: const Icon(Icons.add),
        label: const Text('新建任务'),
      ),
    );
  }
}
