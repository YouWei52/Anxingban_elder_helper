import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api/api_client.dart';

class TaskScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const TaskScreen({super.key, required this.onNavigate});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _apiClient = ApiClient();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: const Text('亲子任务'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.onNavigate('home'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite_outline, size: 24, color: Color(0xFF9C27B0)),
                      const SizedBox(width: 12),
                      Text('创建任务', style: AppTheme.heading3),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: AppTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: '任务内容',
                      hintText: '例如：一起拍张合照',
                      filled: true,
                      fillColor: AppTheme.bgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleCreate,
                    style: AppTheme.primaryButton(),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('创建任务'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCreate() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入任务内容')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final taskData = {
        'profile_id': 1,
        'description': _descriptionController.text,
        'trip_id': null,
      };

      final result = await _apiClient.createTask(taskData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('任务创建成功！ID: ${result['id']}'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
        _descriptionController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('创建失败：${e.toString()}'),
            backgroundColor: AppTheme.dangerColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
