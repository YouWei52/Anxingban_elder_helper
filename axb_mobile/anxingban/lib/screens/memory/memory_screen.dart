import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();

  List<dynamic> _cards = [];
  List<dynamic> _tasks = [];
  bool _isLoadingCards = false;
  bool _isLoadingTasks = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCards();
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    setState(() => _isLoadingCards = true);
    try {
      final result = await _apiClient.getCards(profileId: 1);
      if (mounted) {
        setState(() => _cards = result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('加载卡片失败：${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoadingCards = false);
    }
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoadingTasks = true);
    try {
      final result = await _apiClient.getTasks(profileId: 1);
      if (mounted) {
        setState(() => _tasks = result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('加载任务失败：${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoadingTasks = false);
    }
  }

  Future<void> _deleteCard(int cardId) async {
    try {
      await _apiClient.deleteCard(cardId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('删除成功'), backgroundColor: Colors.green),
        );
        _loadCards();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('删除失败：${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('回忆'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '回忆卡片'),
            Tab(text: '亲子任务'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCardsTab(), _buildTasksTab()],
      ),
    );
  }

  Widget _buildCardsTab() {
    if (_isLoadingCards) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_album_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('还没有回忆卡片', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(
              '完成旅程后会自动生成',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCards,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 64),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card['title'] ?? '无标题',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card['content'] ?? '',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            card['created_at'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
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
          );
        },
      ),
    );
  }

  Widget _buildTasksTab() {
    if (_isLoadingTasks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('还没有任务记录', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final isCompleted = task['status'] == 'completed';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
              title: Text(
                task['description'] ?? '无描述',
                style: TextStyle(
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                task['created_at'] ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: isCompleted
                  ? const Chip(
                      label: Text('已完成', style: TextStyle(fontSize: 12)),
                      backgroundColor: Colors.green,
                      labelStyle: TextStyle(color: Colors.white),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(int cardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个回忆卡片吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCard(cardId);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
