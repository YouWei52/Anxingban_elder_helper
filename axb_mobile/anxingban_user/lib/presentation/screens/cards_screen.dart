import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无回忆卡片',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text('回忆卡片由系统自动生成', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('完成任务后即可查看', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
