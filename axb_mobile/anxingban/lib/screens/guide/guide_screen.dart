import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/api/api_client.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final _questionController = TextEditingController();
  final _apiClient = ApiClient();
  String? _answer;
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: const Text('景点讲解'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
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
                      Icon(
                        Icons.audiotrack_outlined,
                        size: 24,
                        color: AppTheme.warningColor,
                      ),
                      const SizedBox(width: 12),
                      Text('向我提问', style: AppTheme.heading3),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _questionController,
                    maxLines: 3,
                    style: AppTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: '例如：洪崖洞有什么历史故事？',
                      filled: true,
                      fillColor: AppTheme.bgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleAsk,
                    style: AppTheme.primaryButton(),
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
                        : const Text('提问'),
                  ),
                ],
              ),
            ),
            if (_answer != null) ...[
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text('解答', style: AppTheme.heading3),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(_answer!, style: AppTheme.bodyLarge),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleAsk() async {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请输入问题')));
      return;
    }

    setState(() {
      _isLoading = true;
      _answer = null;
    });

    try {
      final result = await _apiClient.askGuide(_questionController.text);
      setState(() {
        _answer = result['answer'] ?? '暂无解答';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('提问失败：${e.toString()}'),
            backgroundColor: AppTheme.dangerColor,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
