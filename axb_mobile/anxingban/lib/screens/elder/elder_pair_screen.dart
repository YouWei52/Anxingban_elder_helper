import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../core/auth/elder_session.dart';

class ElderPairScreen extends StatefulWidget {
  const ElderPairScreen({super.key});

  @override
  State<ElderPairScreen> createState() => _ElderPairScreenState();
}

class _ElderPairScreenState extends State<ElderPairScreen> {
  int? _elderId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadElderId();
  }

  Future<void> _loadElderId() async {
    final id = await ElderSession.elderId();
    setState(() {
      _elderId = id;
      _isLoading = false;
    });
  }

  void _copyId() {
    if (_elderId != null) {
      Clipboard.setData(ClipboardData(text: _elderId.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ID已复制到剪贴板'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('安全配对'),
        backgroundColor: AppTheme.bgColor,
      ),
      backgroundColor: AppTheme.bgColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildIdCard(),
                  const SizedBox(height: 24),
                  _buildInstructions(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppTheme.blueGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppTheme.elevation2Shadow,
          ),
          child: const Icon(Icons.link, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text('我的账号ID', style: AppTheme.heading2),
        const SizedBox(height: 12),
        Text(
          '将此ID提供给子女即可建立关联',
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIdCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Text(
            '账号ID',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            _elderId?.toString() ?? '未知',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _copyId,
              icon: const Icon(Icons.copy, size: 24),
              label: const Text('复制ID'),
              style: AppTheme.primaryButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.info, size: 28),
              const SizedBox(width: 12),
              Text(
                '使用说明',
                style: AppTheme.heading3.copyWith(color: AppTheme.info),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInstructionItem('1', '点击"复制ID"按钮复制您的账号ID'),
          _buildInstructionItem('2', '将ID通过微信、电话等方式发送给子女'),
          _buildInstructionItem('3', '子女在"安全配对"页面输入ID即可完成绑定'),
          _buildInstructionItem('4', '绑定后，子女可以为您创建行程和任务'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.info,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: AppTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
