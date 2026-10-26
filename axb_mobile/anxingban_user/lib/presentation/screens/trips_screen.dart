import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 80, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              '暂无行程',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text('点击右下角按钮创建新行程', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/trips/create'),
        icon: const Icon(Icons.add),
        label: const Text('新建行程'),
      ),
    );
  }
}
