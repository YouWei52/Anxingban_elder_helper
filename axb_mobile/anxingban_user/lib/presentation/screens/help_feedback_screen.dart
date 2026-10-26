import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({super.key});

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助与反馈'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection(context),
          const SizedBox(height: 24),
          _buildFeedbackSection(context),
        ],
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('常见问题', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildFaqItem(
          context,
          question: '如何添加老人档案？',
          answer: '进入"档案管理"页面，点击"添加档案"按钮，输入老人的用户ID即可关联。',
        ),
        _buildFaqItem(
          context,
          question: '如何创建行程？',
          answer: '在"行程管理"页面，点击右下角的"新建行程"按钮，填写目的地和出行日期。',
        ),
        _buildFaqItem(
          context,
          question: '什么是SOS记录？',
          answer: 'SOS记录是老人发出紧急求助时的记录，您可以在"SOS记录"页面查看历史记录。',
        ),
      ],
    );
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(question),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('问题反馈', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: '请描述您遇到的问题或建议...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '请输入反馈内容';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitFeedback,
                      child: const Text('提交反馈'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('反馈已提交，感谢您的建议！')));
      _feedbackController.clear();
    }
  }
}
