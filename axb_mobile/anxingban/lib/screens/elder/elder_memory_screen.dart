import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';
import '../../core/auth/elder_session.dart';
import '../../core/theme/app_theme.dart';

class ElderMemoryScreen extends StatefulWidget {
  const ElderMemoryScreen({super.key});

  @override
  State<ElderMemoryScreen> createState() => _ElderMemoryScreenState();
}

class _ElderMemoryScreenState extends State<ElderMemoryScreen> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _cards = [];
  bool _isLoading = false;
  int? _profileId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    _profileId = await ElderSession.profileId();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiClient.getCards(profileId: _profileId);
      if (mounted) {
        setState(() => _cards = result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('加载失败：${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的回忆')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_album_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text('还没有回忆卡片', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showGenerateDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('生成回忆卡片'),
                    style: AppTheme.primaryButton(),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadCards,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return _buildCardItem(card);
                },
              ),
            ),
      floatingActionButton: _cards.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showGenerateDialog(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildCardItem(Map<String, dynamic> card) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showCardDetail(card),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card['image_url'] != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  card['image_url'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 48),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['title'] ?? '未命名',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card['summary'] ?? '',
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        card['created_at'] ?? '',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteDialog(card['id']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetail(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (card['image_url'] != null)
                Image.network(
                  card['image_url'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card['title'] ?? '未命名',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      card['summary'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      card['created_at'] ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGenerateDialog() {
    // TODO: 让用户选择行程后生成
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('请在行程详情页生成回忆卡片')));
  }

  void _showDeleteDialog(int cardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除卡片'),
        content: const Text('确定要删除这张回忆卡片吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCard(cardId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCard(int cardId) async {
    try {
      await _apiClient.deleteCard(cardId);
      _loadCards();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('删除成功')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('删除失败：${e.toString()}')));
      }
    }
  }
}
