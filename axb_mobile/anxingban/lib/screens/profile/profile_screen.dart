import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/api/api_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _profile;
  bool _isLoading = false;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _childNameController = TextEditingController();
  final _childPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _childNameController.dispose();
    _childPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiClient.getProfile(1);
      if (mounted) {
        setState(() {
          _profile = result;
          _parentNameController.text = result['parent_name'] ?? '';
          _parentPhoneController.text = result['parent_phone'] ?? '';
          _childNameController.text = result['child_name'] ?? '';
          _childPhoneController.text = result['child_phone'] ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('加载失败：${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _apiClient.updateProfile({
        'id': 1,
        'parent_name': _parentNameController.text,
        'parent_phone': _parentPhoneController.text,
        'child_name': _childNameController.text,
        'child_phone': _childPhoneController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('更新成功'), backgroundColor: Colors.green),
        );
        setState(() => _isEditing = false);
        _loadProfile();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('更新失败：${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          if (!_isEditing && _profile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading && _profile == null
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
          ? _buildCreateProfile()
          : _isEditing
          ? _buildEditForm()
          : _buildProfileView(),
    );
  }

  Widget _buildCreateProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('还没有档案', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _isEditing = true),
            style: AppTheme.primaryButton(),
            child: const Text('创建档案'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.elderly,
                  title: '长辈姓名',
                  value: _profile!['parent_name'] ?? '-',
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  icon: Icons.phone,
                  title: '长辈电话',
                  value: _profile!['parent_phone'] ?? '-',
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  icon: Icons.child_care,
                  title: '子女姓名',
                  value: _profile!['child_name'] ?? '-',
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  icon: Icons.phone_android,
                  title: '子女电话',
                  value: _profile!['child_phone'] ?? '-',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('档案ID'),
                  trailing: Text('${_profile!['id']}'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('创建时间'),
                  subtitle: Text(_profile!['created_at'] ?? '-'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '编辑档案',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _parentNameController,
            decoration: const InputDecoration(
              labelText: '长辈姓名',
              prefixIcon: Icon(Icons.elderly),
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? '请输入姓名' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _parentPhoneController,
            decoration: const InputDecoration(
              labelText: '长辈电话',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) return '请输入电话';
              if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value!)) {
                return '请输入有效的手机号';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _childNameController,
            decoration: const InputDecoration(
              labelText: '子女姓名',
              prefixIcon: Icon(Icons.child_care),
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? '请输入姓名' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _childPhoneController,
            decoration: const InputDecoration(
              labelText: '子女电话',
              prefixIcon: Icon(Icons.phone_android),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) return '请输入电话';
              if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value!)) {
                return '请输入有效的手机号';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() => _isEditing = false);
                          if (_profile != null) _loadProfile();
                        },
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: AppTheme.primaryButton(),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('保存'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
