import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api/api_client.dart';

class CardScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const CardScreen({super.key, required this.onNavigate});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final _apiClient = ApiClient();
  bool _isLoading = false;

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: const Text('回忆卡片'),
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
                      Icon(Icons.photo_album_outlined, size: 24, color: AppTheme.successColor),
                      const SizedBox(width: 12),
                      Text('生成纪念卡片', style: AppTheme.heading3),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '为您的旅行生成精美的纪念卡片',
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleGenerate,
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
                        : const Text('生成卡片'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGenerate() async {
    setState(() => _isLoading = true);

    try {
      final cardData = {
        'trip_id': 1,
        'title': '美好的旅行回忆',
        'content': '这是一次难忘的旅程',
      };

      final result = await _apiClient.generateCard(cardData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('卡片生成成功！ID: ${result['id']}'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('生成失败：${e.toString()}'),
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
